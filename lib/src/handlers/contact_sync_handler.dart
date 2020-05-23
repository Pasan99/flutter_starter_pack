import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/contact_pagination_request_api.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class ContactSyncHandler {
  static const _CONTACT_ITEMS_FOR_A_PAGE = 10;
  int _contactPageCount = 1;

  ///sync contacts data from server to local DB
  Future<void> syncContacts(BuildContext context) async {
    try {
      ContactPaginationRequestAPI api = await _getContactPaginationData(
          context, _contactPageCount, _CONTACT_ITEMS_FOR_A_PAGE);

      if (api != null &&
          api.errorBody == null &&
          !api.itemList.isInvalid() &&
          api.itemList[0].total > 0 &&
          api.itemList[0].total >
              _contactPageCount * _CONTACT_ITEMS_FOR_A_PAGE) {
        _contactPageCount++;
        syncContacts(
            context); //repeat this until we sync all available data from the server
      }
    } catch (e) {
      print(e);
    }
  }

  ///get available contacts pagination data from the server
  Future<ContactPaginationRequestAPI> _getContactPaginationData(
      BuildContext context, int page, int size) async {
    UserEntity currentUser = await UserAuth().getCurrentUser();

    APIRequests request = APIRequests();
    ContactPaginationRequestAPI result = await request.execute(
        APIConstants.BASE_URL +
            APIConstants.API_POST_CONTACTS +
            '/' +
            currentUser.authId +
            '?page=' +
            page.toString() +
            '&size=' +
            size.toString(),
        context,
        authToken: "",
        responseClass: ContactPaginationRequestAPI(),
        apiMethod: ApiMethod.GET);

    if (result == null ||
        result.errorBody != null ||
        result.itemList.isInvalid() ||
        result.itemList[0].total == 0 ||
        result.itemList[0].data.isInvalid()) {
      return Future.value(null);
    }

    result.itemList[0].data.forEach((contact) {
      _updateLocalDB(contact); //update local DB with api response data
    });

    return Future.value(result);
  }

  ///update local database with server response [result]
  Future<void> _updateLocalDB(ContactsRequestAPI result) async {
    if (result == null) return;

    await ContactDAO().deleteData(ContactEntity());

    _saveContactInLocalDB(result);
  }

  ///save given contact details in local DB
  Future<bool> _saveContactInLocalDB(ContactsRequestAPI result) async {
    ContactDAO contactDAO = ContactDAO();
    print(ContactEntity().convertToContactEntity(result));
    bool a = (await contactDAO
            .insertData(ContactEntity().convertToContactEntity(result))) >=
        0;
    return Future.value(a);
  }

  ///update given contact details in local DB
  Future<bool> _updateContactInLocalDB(ContactsRequestAPI result) async {
    ContactDAO contactDAO = ContactDAO();
    print(ContactEntity().convertToContactEntity(result));
    bool a = (await contactDAO.updateData(
        ContactEntity().convertToContactEntity(result),
        where: '_id = ?',
        whereArgs: [result.contactID]));
    return Future.value(a);
  }
}

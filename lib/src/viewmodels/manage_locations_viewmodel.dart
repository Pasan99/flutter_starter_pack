import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
import 'package:food_deliver/src/db/dao/city_dao.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/dao/district_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ui/widgets/store_animated_list.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class ManageLocationViewModel with ChangeNotifier, DataSetChangedListener {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final VoidCallback callback;
  List<ContactEntity> userContacts = List();
  ScrollController scrollController;

  ManageLocationViewModel({this.callback}) {}

  @override
  onOffsetChanged() {
    return null;
  }

  @override
  onScrollDown() {
    return null;
  }

  @override
  onScrollUp() {
    return null;
  }

  Future<bool> loadMore(){
    Future.delayed(Duration(milliseconds: 100)).then((val){
      return Future.value(true);
    });
  }

  ///load all available contact details from the local DB
  Future<void> loadContactDetails() async {
    try {
      List<ContactEntity> entities = await ContactDAO()
          .getMatchingEntries(ContactEntity(), orderBy: 'ID DESC');
      userContacts = entities;
      notifyListeners();
      callback();
    } catch (e) {
      print(e);
    }
  }

  ///remove a location data by given [contactID] from server and from Local DB
  Future<bool> removeSelectedLocation(
      String contactID, BuildContext context) async {

    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      APIRequests request = APIRequests();
      ContactsRequestAPI result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_POST_CONTACTS +
              '/' +
              currentUser.authId +
              '/' +
              contactID,
          context,
          authToken: "",
          responseClass: ContactsRequestAPI(),
          apiMethod: ApiMethod.DELETE);

      if (result == null || result.errorBody != null) {
        return Future.value(false);
      }

      if (await _updateContactInLocalDB(contactID)) {
        await clearCart(contactID, currentUser);
        notifyListeners();
        print(result.name);
        callback();
        return Future.value(true);
      }
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> clearCart(String contactId, UserEntity currentUser) async {
    bool status = false;
    if (currentUser.selectedContactId == contactId) {
      status = await CartItemDAO().deleteFromRawQuery(CartItemEntity(),
          "DELETE FROM ${CartItemEntity().runtimeType.toString()}");
    }
    else{
      return true;
    }
    return status;
  }

  ///remove given contact details from local DB
  Future<bool> _updateContactInLocalDB(String contactID) async {
    ContactDAO contactDAO = ContactDAO();
    bool a = (await contactDAO
        .deleteData(ContactEntity(), where: '_id = ?', whereArgs: [contactID]));
    return Future.value(a);
  }

  ///get district and city details according to the given city id
  Future<void> _loadCityDetails(
      String cityID, ContactEntity contactEntity) async {
    try {
      CityEntity cityEntity = await CityDAO()
          .getMatchingEntry(CityEntity(), where: 'cityID = "$cityID"');
      if (cityEntity == null) return Future.value();

      DistrictEntity districtEntity = await DistrictDAO().getMatchingEntry(
          DistrictEntity(),
          where: 'ID = "${cityEntity.districtId}"');
      if (districtEntity == null) return Future.value();

      contactEntity.districtName =
          await LanguageHelper(names: districtEntity.districtName).getName();
      contactEntity.cityName =
          await LanguageHelper(names: cityEntity.name).getName();
    } catch (e) {
      print(e);
    }
    return Future.value();
  }
}

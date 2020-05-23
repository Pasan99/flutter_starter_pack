import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/handlers/contact_sync_handler.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/values/strings.dart';

//const DefaultCityId = "5e8c18869bb7e53203ac4ffb";
const DefaultCityId = "5e96e044139dc65764da7855";

class CategoryBasedStoreViewModel with ChangeNotifier {
  List<StoreResponseApi> stores = List<StoreResponseApi>();
  List<StoreDropDownModel> addressList = List();
  ScrollController scrollController;
  UserEntity currentUser;
  int selectedContactIndex;
  StoreDropDownModel selectedUser;
  Responses currentStatus = Responses.ONGOING;
  String newContact;
  BuildContext context;
  bool isCartCleared = false;

  final CategoryResponseApi categoryResponseApi;
  static final String DELIVER_TO_SOMEONE = "Deliver to Someone Else";

  final size = 10;
  int currentPage = 1;

  CategoryBasedStoreViewModel({this.context, this.categoryResponseApi}) {
    loadDropDownList();
  }

  retry() {
    if (stores != null) {
      stores.clear();
    }
    currentStatus = Responses.ONGOING;
    notifyListeners();
    loadDropDownList();
  }

  loadDropDownList() async {
    try {
      await ContactSyncHandler().syncContacts(null);
      if (await UserAuth().renewUser()) {
        print(addressList);
        currentUser = await UserAuth().getCurrentUser();
        if (currentUser != null) {
          addressList = List<StoreDropDownModel>();
          String city = "";
          //await CityDistrictHelper(cityId: currentUser.cityId).getCity();
          StoreDropDownModel person = StoreDropDownModel(
              contactId: "me",
              cityId: currentUser.cityId,
              city: city,
              personName:
                  "${currentUser.houseNo != null ? currentUser.houseNo + ", " : ""}"
                  "${currentUser.street != null ? currentUser.street : ""}",
              gpsCoordinates: currentUser.gpsCoordinates);
          this.addressList.add(person);
          // select current user as selected user

          // load other contact addresses
          ContactDAO contactDAO = ContactDAO();
          List<ContactEntity> contacts =
              await contactDAO.getMatchingEntries(ContactEntity());
          if (contacts != null) {
            for (int i = 0; i < contacts.length; i++) {
              String city = "";
              //await CityDistrictHelper(cityId: contacts[i].cityId).getCity();
              print("City : ${contacts[i].cityId}");
              StoreDropDownModel person = StoreDropDownModel(
                  contactId: contacts[i].contactID,
                  cityId: contacts[i].cityId,
                  city: city,
                  personName:
                      "${contacts[i].houseNo != null ? contacts[i].houseNo + ", " : ""}"
                      "${contacts[i].street != null ? contacts[i].street : ""}",
                  gpsCoordinates: contacts[i].gpsCoordinates);
              this.addressList.add(person);
            }
          }

          this.addressList.add(StoreDropDownModel(
              personName: DELIVER_TO_SOMEONE,
              contactId: "other",
              city: "",
              cityId: "",
              gpsCoordinates: null));

          await getSelectedContact();

          // used for when selection deliver to someone else
          if (newContact != null) {
            addressList.forEach((address) {
              if (address.contactId == newContact) {
                selectedContactIndex = addressList.indexOf(address);
              }
            });
          }
          onCityChanged(addressList[selectedContactIndex]);

          notifyListeners();
        }
      }
    } catch (i) {
      print(i);
    }
  }

  getSelectedContact() {
    print("Selected Contact : ${currentUser.selectedContactId}");
    if (currentUser.selectedContactId != "me") {
      if (!addressList.isInvalid()) {
        StoreDropDownModel s;
        addressList.forEach((address) {
          if (address.contactId == currentUser.selectedContactId) {
            s = address;
          }
        });
        if (s != null) {
          selectedContactIndex = addressList.indexOf(s);
        } else {
          selectedContactIndex = 0;
        }
      } else {
        selectedContactIndex = 0;
      }
    } else {
      selectedContactIndex = 0;
    }
    print(selectedContactIndex);
  }

  onCityChanged(StoreDropDownModel person) async {
    if (currentUser.selectedContactId != person.contactId) {
      await clearCart();
    }
    StoreDropDownModel selected;
    for (StoreDropDownModel item in addressList) {
      if (person.personName == item.personName) {
        selected = item;
      }
    }
    if (selected != null) {
      currentPage = 1;
      await setSelectedAddress(selected);
      selectedUser = selected;
      notifyListeners();
      if (stores != null) {
        stores.clear();
      }
      currentStatus =
          await getItems(selected.cityId, selected.gpsCoordinates, context);
      notifyListeners();
    }
  }

  Future<Responses> getItems(String cityId, GpsCoordinates gpsCoordinates,
      BuildContext context) async {
    try {
      APIRequests request = APIRequests();
//      String url = new StorePaginationUrlCreator(
//              categoryId: categoryResponseApi.Id,
//              cityId: cityId == null ? currentUser.cityId : cityId,
//              page: currentPage,
//              size: size,
//              gpsCoordinates: gpsCoordinates)
//          .getUrl();

      String url = "${categoryResponseApi.Id}?lng=79.86133555273437&lat=9.861244";
//      String url = "${categoryResponseApi.Id}?lng=${gpsCoordinates.coordinates[1]}&lat=${gpsCoordinates.coordinates[0]}";

      List<StoreResponseApi> result = await request.getList(
          APIConstants.BASE_URL + APIConstants.API_GET_STORES_BY_CATEGORY + url,
          context,
          authToken: "",
          body: "",
          responseClass: StoreResponseApi());
      print(result);

      if (stores == null || stores.isEmpty) {
        this.stores = result;
      } else {
        this.stores.addAll(result);
      }

      if (stores != null && stores.isNotEmpty && stores[0].errorBody == null) {
        // Set Store Names
        stores.forEach((store) async {
          store.cityName =
              await LanguageHelper(names: store.cityNames).getName();
          store.storeName =
              await LanguageHelper(names: store.storeNames).getName();
//          store.packages.forEach((package) async {
//            package.packageName =
//                await LanguageHelper(names: package.packageNames).getName();
//            if (package.items == null) {
//              print(store.storeName);
//            } else {
//              package.items.forEach((packageItem) async {
//                packageItem.productName =
//                    await LanguageHelper(names: packageItem.productNames)
//                        .getName();
//              });
//            }
//          });
          notifyListeners();
        });

        currentPage++;
        notifyListeners();
        print("new result" + this.stores.length.toString());
        return Responses.DATA_RETRIEVED;
      } else {
        return Responses.NO_DATA;
      }
    } catch (e) {
      print(e);
      return Responses.TIMEOUT;
    }
//    else {
//      return Responses.NETWORK_DISCONNECTED;
//    }
  }

  Future<void> setSelectedAddress(StoreDropDownModel selected) async {
    if (!selected.contactId.isInvalid()) {
      if (selected.contactId == "me") {
        UserAuth().setSelectedContact(contactId: "me");
      } else {
        UserAuth().setSelectedContact(contactId: selected.contactId);
        await UserAuth().renewUser();
      }
    }

    return Future.value();
  }

  Future<bool> clearCart() async {
    bool a = await CartItemDAO().deleteFromRawQuery(CartItemEntity(),
        "DELETE FROM ${CartItemEntity().runtimeType.toString()}");
    isCartCleared = true;
    return a;
  }

  Future<bool> loadMore() async {
    Responses response;
    if (selectedUser != null) {
      response = await getItems(
          selectedUser.cityId, selectedUser.gpsCoordinates, context);
      print("Load More");
    }
    if (response == Responses.DATA_RETRIEVED) {
      return true;
    }
    return false;
  }

  clearAllPackagesAddedHistory() {
//    stores.forEach((store) {
//      if (store.packages != null) {
//        store.packages.forEach((package) {
//          if (package != null) {
//            package.isAddedToCart = false;
//            package.inCartCount = 1;
//          }
//        });
//      }
//    });
  }
}

class StoreDropDownModel {
  String city;
  String cityId;
  String personName;
  String contactId;
  GpsCoordinates gpsCoordinates;

  StoreDropDownModel(
      {@required this.cityId,
      @required this.city,
      @required this.personName,
      @required this.contactId,
      @required this.gpsCoordinates});
}

class StorePaginationUrlCreator {
  String cityId;
  final int page;
  final int size;
  final GpsCoordinates gpsCoordinates;
  final String categoryId;

  StorePaginationUrlCreator(
      {@required this.cityId,
      @required this.page,
      @required this.size,
      @required this.gpsCoordinates,
      @required this.categoryId});

  String getUrl() {
    return "/$DefaultCityId/${gpsCoordinates.coordinates[0]}/${gpsCoordinates.coordinates[1]}?page=$page&size=$size";
  }
}

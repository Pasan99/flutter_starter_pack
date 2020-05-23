import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/api/models/request/user_requset_api.dart';
import 'package:food_deliver/src/api/models/response/user_response_api.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateUserViewModel with ChangeNotifier {
  UserRequestApi userModel;
  UserEntity localUser;
  int districtId = -1; //districtId in city entity (foreign key)
  String cityID

      /*= "5e8a8e8a7ad66f0722bd7a3a"*/;

  String contactID;

  // controllers for textFields
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController nic = new TextEditingController();
  TextEditingController mainRoad = new TextEditingController();
  TextEditingController street = new TextEditingController();
  TextEditingController houseNo = new TextEditingController();
  TextEditingController landMarks = new TextEditingController();
  TextEditingController contactNo = new TextEditingController();
  var district = ValueNotifier<TextEditingController>(TextEditingController());
  var city = ValueNotifier<TextEditingController>(TextEditingController());

  LatLng selectedLocation;

  Future<UserResponseApi> createUser(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (selectedLocation == null ||
          selectedLocation.latitude == 0 ||
          selectedLocation.longitude == 0) return Future.value(null);

      List<String> landmarks = new List();
      if (!landMarks.value.text.isInvalid()) {
        landmarks = landMarks.text.split(",");
      }
      userModel = UserRequestApi(
          name: firstName.value.text + " " + lastName.value.text,
          mobileNumber: currentUser.mobileNumber,
          nic: nic.text,
          cityId: cityID,
          mainRoad: mainRoad.text,
          street: street.text,
          houseNo: houseNo.text,
          landMarks: landmarks,
          gpsCoordinates: GpsCoordinates(coordinates: [
            selectedLocation.latitude,
            selectedLocation.longitude
          ]),
          language: currentUser.language);

      APIRequests request = APIRequests();
      UserResponseApi result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_CREATE_USER +
              "/${currentUser.authId}",
          context,
          authToken: "",
          body: jsonEncode(userModel.toMap(withoutUniqueIDs: false)),
          responseClass: UserResponseApi(),
          apiMethod: ApiMethod.PUT);

      if (result.errorBody == null) {
        saveInLocalDb(result);
        notifyListeners();
        print(result.name);
        return Future.value(result);
      } else {
        return Future.value(null);
      }
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<bool> saveInLocalDb(UserResponseApi result) async {
    UserDAO userDAO = UserDAO();
    UserEntity currentUser = await UserAuth().getCurrentUser();
    UserEntity newUser = UserEntity().convertToUserEntity(result);
    newUser.selectedContactId = "me";
    bool a =
        await userDAO.updateData(newUser, where: "ID == '${currentUser.ID}'");
    return a;
  }

  Future<bool> isLoggedIn() async {
    UserDAO dao = UserDAO();
    localUser = UserEntity();
    localUser = await dao.getMatchingEntry(localUser,
        where: "authId IS NOT NULL AND name IS NOT NULL");
    if (localUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveLanguageInLocalDb(UserEntity userEntity) async {
    try {
      UserDAO userDAO = UserDAO();
      int a = await userDAO.insertData(userEntity);
      print(a);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isSaveLanguage() async {
    UserDAO dao = UserDAO();
    UserEntity userEntity = UserEntity();
    bool result = await dao.isExists(userEntity);
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateLanguageInLocalDb(UserEntity userEntity) async {
    try {
      UserDAO userDAO = UserDAO();
      bool up1 = await userDAO.updateData(userEntity);
      print(up1);
    } catch (e) {
      print(e);
    }
  }

//  Future<void> getLanguageFromLocalDb(UserEntity userEntity) async {
//    try{
//      UserDAO userDAO = UserDAO();
//      String res = await userDAO.(userEntity);
//      print(res);
//    }
//    catch (e){
//      print(e);
//    }
//  }

  ///create new contact with given details
  Future<ContactsRequestAPI> createNewContact(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (selectedLocation == null ||
          selectedLocation.latitude == 0 ||
          selectedLocation.longitude == 0) return Future.value(null);

      List<String> landmarks = new List();
      if (!landMarks.value.text.isInvalid()) {
        landmarks = landMarks.text.split(",");
      }
      ContactsRequestAPI contactModel = ContactsRequestAPI(
          name: firstName.value.text + " " + lastName.value.text,
          nicNumber: nic.text,
          cityId: cityID,
          mainRoad: mainRoad.text,
          street: street.text,
          houseNo: houseNo.text,
          landmarks: landmarks,
          gpsCoordinates: GpsCoordinates(coordinates: [
            selectedLocation.latitude,
            selectedLocation.longitude
          ]),
          contactNumber: contactNo.text,
          userID: currentUser.authId);

      APIRequests request = APIRequests();
      ContactsRequestAPI result = await request.execute(
          APIConstants.BASE_URL + APIConstants.API_POST_CONTACTS, context,
          authToken: "",
          body: jsonEncode(contactModel.toMap()),
          responseClass: ContactsRequestAPI(),
          apiMethod: ApiMethod.POST);

      if (result == null || result.errorBody != null) {
        return Future.value(null);
      }

      if (await _saveContactInLocalDB(result)) {
        notifyListeners();
        print(result.name);
        return Future.value(result);
      }
    } catch (e) {
      print(e);
      return Future.value(null);
    }
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

  ///update existing contact with given details
  Future<ContactsRequestAPI> updateExistingContact(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (selectedLocation == null ||
          selectedLocation.latitude == 0 ||
          selectedLocation.longitude == 0) return Future.value(null);

      List<String> landmarks = new List();
      if (!landMarks.value.text.isInvalid()) {
        landmarks = landMarks.text.split(",");
      }
      ContactsRequestAPI contactModel = ContactsRequestAPI(
          name: firstName.value.text + " " + lastName.value.text,
          nicNumber: nic.text,
          cityId: cityID,
          mainRoad: mainRoad.text,
          street: street.text,
          houseNo: houseNo.text,
          landmarks: landmarks,
          gpsCoordinates: GpsCoordinates(coordinates: [
            selectedLocation.latitude,
            selectedLocation.longitude
          ]),
          contactNumber: contactNo.text,
          userID: currentUser.authId);

      APIRequests request = APIRequests();
      ContactsRequestAPI result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_POST_CONTACTS +
              '/' +
              contactID,
          context,
          authToken: "",
          body: jsonEncode(contactModel.toMap()),
          responseClass: ContactsRequestAPI(),
          apiMethod: ApiMethod.PUT);

      if (result == null || result.errorBody != null) {
        return Future.value(null);
      }

      if (await _updateContactInLocalDB(result)) {
        notifyListeners();
        print(result.name);
        return Future.value(result);
      }
    } catch (e) {
      print(e);
      return Future.value(null);
    }
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

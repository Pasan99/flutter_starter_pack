import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/api/models/request/user_requset_api.dart';
import 'package:food_deliver/src/api/models/response/user_response_api.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';

const DefaultCityId = "5e96e044139dc65764da7855";
//const DefaultCityId = "5e8c18869bb7e53203ac4ffb";

class RegisterLocationViewModel extends ChangeNotifier {
  static String kGoogleApiKey = "AIzaSyDixIUCehVT_rvCPGHWc2EoemsQmuTgtGY";
  static String geoCodingGoogleApiKey = "AIzaSyCJUurpysRkPjuJfRzSKUOyxeymxmFvw9w";

  BottomSheetModel bottomSheetModel = new BottomSheetModel();
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  int registrationType;
  bool isUpdating = false;

  // location changed value
  bool isChanged = false;
  bool isFirstTime = true;

  // User data
  UserEntity localUser;
  UserRequestApi requestUser;
  UserEntity currentUser;
  String updateContactId;

  RegisterLocationViewModel(String contactId, int registrationType) {
    // check system - ios/android
    if (Platform.isIOS){
      RegisterLocationViewModel.geoCodingGoogleApiKey = "AIzaSyC6GboNcZOs0VudDwQ8le2kW-mA5XTE0P8";
      RegisterLocationViewModel.kGoogleApiKey = "AIzaSyCbRlqD77pzPnGY5ds-L5SvgOn7bi2Pmyk";
    }

    this.updateContactId = contactId;
    this.registrationType = registrationType;
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    currentUser = await UserAuth().getCurrentUser();

    // load details to edit
    if (registrationType ==
        LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS) {
      _loadUserDetails();
    }
    if (registrationType ==
        LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS) {
      _loadContactDetails();
    }
  }

  // Google places API location prediction
  Future<BottomSheetModel> displayPrediction(Prediction p) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      print("${p.description} - $lat/$lng");
      bottomSheetModel.address = p.description;
      bottomSheetModel.lat = lat;
      bottomSheetModel.lng = lng;

      notifyListeners();

      isChanged = true;

      return bottomSheetModel;
    }
    return null;
  }

  // Google geo coding - get the address from gps coordinates
  Future<BottomSheetModel> getAddress(LatLng latLng) async {
    // From coordinates
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    List<Address> addresses =
        await Geocoder.google(geoCodingGoogleApiKey, language: "en")
            .findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    bottomSheetModel.address = first.addressLine;
    notifyListeners();
    isUpdating = false;
    return bottomSheetModel;
  }

  Future<BottomSheetModel> setAddress(double latitude, double longitude) async {
    // From coordinates
    bottomSheetModel.lat = latitude;
    bottomSheetModel.lng = longitude;
    notifyListeners();
    return bottomSheetModel;
  }

  /// USER CREATION
  // new user
  Future<UserResponseApi> createUser(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (bottomSheetModel == null ||
          bottomSheetModel.lat == 0 ||
          bottomSheetModel.lng == 0) return Future.value(null);

      requestUser = UserRequestApi(
          name: bottomSheetModel.name,
          cityId: DefaultCityId,
          street: bottomSheetModel.address,
          houseNo: bottomSheetModel.houseNo,
          landMarks: bottomSheetModel.landmark,
          gpsCoordinates: GpsCoordinates(
              coordinates: [bottomSheetModel.lat, bottomSheetModel.lng]),
          language: currentUser.language);

      APIRequests request = APIRequests();
      UserResponseApi result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_CREATE_USER +
              "/${currentUser.authId}",
          context,
          authToken: "",
          body: jsonEncode(requestUser.toMap(withoutUniqueIDs: false)),
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

  // save user
  Future<bool> saveInLocalDb(UserResponseApi result) async {
    UserDAO userDAO = UserDAO();
    UserEntity currentUser = await UserAuth().getCurrentUser();
    UserEntity newUser = UserEntity().convertToUserEntity(result);
    newUser.selectedContactId = "me";
    bool a =
        await userDAO.updateData(newUser, where: "ID == '${currentUser.ID}'");
    return a;
  }

  // login checker
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

  // get current user details from the DB
  Future<void> _loadUserDetails() async {
    await UserAuth().renewUser();
    UserAuth().getCurrentUser().then((user) {
      if (user == null || user.toMap() == null || user.toMap().isEmpty) return;
      currentUser = user;
      bottomSheetModel.name = user.name;
      bottomSheetModel.address = user.street ?? '';
      bottomSheetModel.houseNo = user.houseNo ?? '';
      bottomSheetModel.landmark =
          user.landMarks == null ? List() : user.landMarks;
      bottomSheetModel.lat = user.gpsCoordinates.coordinates[0];
      bottomSheetModel.lng = user.gpsCoordinates.coordinates[1];
      notifyListeners();
      isChanged = true;
    }, onError: (e) => print(e)).catchError((e) => print(e));
  }

  /// CONTACTS
  //create new contact with given details
  Future<ContactsRequestAPI> createNewContact(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (bottomSheetModel.address == null ||
          bottomSheetModel.lat == 0 ||
          bottomSheetModel.lat == 0) return Future.value(null);
      ContactsRequestAPI contactModel = ContactsRequestAPI(
          name: bottomSheetModel.name,
          cityId: DefaultCityId,
          street: bottomSheetModel.address,
          houseNo: bottomSheetModel.houseNo,
          landmarks: bottomSheetModel.landmark,
          gpsCoordinates: GpsCoordinates(
              coordinates: [bottomSheetModel.lat, bottomSheetModel.lng]),
          contactNumber: "+94" + int.parse(bottomSheetModel.contactNo).toString(),
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

  //save given contact details in local DB
  Future<bool> _saveContactInLocalDB(ContactsRequestAPI result) async {
    ContactDAO contactDAO = ContactDAO();
    print(ContactEntity().convertToContactEntity(result));
    bool a = (await contactDAO
            .insertData(ContactEntity().convertToContactEntity(result))) >=
        0;
    return Future.value(a);
  }

  //update existing contact with given details
  Future<ContactsRequestAPI> updateExistingContact(BuildContext context) async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();

      if (updateContactId == null ||
          bottomSheetModel.address == null ||
          bottomSheetModel.lat == 0 ||
          bottomSheetModel.lng == 0) return Future.value(null);
      print(bottomSheetModel.landmark.toString());

      ContactsRequestAPI contactModel = ContactsRequestAPI(
          name: bottomSheetModel.name,
          cityId: DefaultCityId,
          street: bottomSheetModel.address,
          houseNo: bottomSheetModel.houseNo,
          landmarks: bottomSheetModel.landmark,
          gpsCoordinates: GpsCoordinates(
              coordinates: [bottomSheetModel.lat, bottomSheetModel.lng]),
          contactNumber: "+94" + int.parse(bottomSheetModel.contactNo).toString(),
          userID: currentUser.authId);

      APIRequests request = APIRequests();
      ContactsRequestAPI result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_POST_CONTACTS +
              '/' +
              updateContactId,
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

  //update given contact details in local DB
  Future<bool> _updateContactInLocalDB(ContactsRequestAPI result) async {
    ContactDAO contactDAO = ContactDAO();
    print(ContactEntity().convertToContactEntity(result));
    bool a = (await contactDAO.updateData(
        ContactEntity().convertToContactEntity(result),
        where: '_id = ?',
        whereArgs: [result.contactID]));
    return Future.value(a);
  }

  //get given contact details from the DB
  Future<void> _loadContactDetails() async {
    ContactEntity contact = await ContactDAO()
        .getMatchingEntry(ContactEntity(), where: '_id = "$updateContactId"');
    if (contact == null || contact.toMap() == null || contact.toMap().isEmpty)
      return;

    bottomSheetModel.name = contact.name;
    bottomSheetModel.address = contact.street;
    bottomSheetModel.houseNo = contact.houseNo;
    bottomSheetModel.landmark = contact.landmarks;
    bottomSheetModel.contactNo = contact.contactNumber.length == 12 ? contact.contactNumber.substring(3, 12):contact.contactNumber;
    bottomSheetModel.lat = contact.gpsCoordinates.coordinates[0];
    bottomSheetModel.lng = contact.gpsCoordinates.coordinates[1];
    notifyListeners();
    isChanged = true;
  }
}

class BottomSheetModel {
  String name;
  String address;
  String houseNo;
  List<String> landmark = List();
  double lat = 0;
  double lng = 0;
  String contactNo;
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/phone_number_request_api.dart';
import 'package:food_deliver/src/api/models/response/otp_verification_response.dart';
import 'package:food_deliver/src/api/models/response/phone_number_response_api.dart';
import 'package:food_deliver/src/api/models/response/user_response_api.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OtpVerificationViewModel {
  PhoneNumberRequestApi userModel;
  UserEntity localUser;
  TextEditingController otpController = TextEditingController();
  UserResponseApi cloudUser;

  String phoneNumber;
  bool isVerified = false;
  String _userId;

  OtpVerificationViewModel(BuildContext context, {@required this.phoneNumber});

  Future<PhoneNumberResponseApi> createUser(BuildContext context) async {
    try {
      userModel = PhoneNumberRequestApi(mobileNumber: this.phoneNumber);

      APIRequests request = APIRequests();
      print("here");
      PhoneNumberResponseApi result = await request.execute(
          APIConstants.BASE_URL +
              APIConstants.API_OTP +
              HttpRequestParameters.OTP_REQUEST_URL_PARAM,
          context,
          authToken: "",
          body: jsonEncode(userModel.toMap(withoutUniqueIDs: false)),
          responseClass: PhoneNumberResponseApi(),
          apiMethod: ApiMethod.POST);

      if (result.errorBody == null) {
        print("Heror");
        _userId = result.Id;
        isVerified = true;
        return Future.value(result);
      } else {
        return Future.value(null);
      }
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<bool> isLoggedIn() async {
    UserEntity currentUser = await UserAuth().getCurrentUser();
    if (!currentUser.mobileNumber.isInvalid()) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> saveInLocalDb() async {
    if (isVerified && _userId != null) {
      UserDAO userDAO = UserDAO();
      UserEntity user = UserEntity();
      UserEntity currentUser = await UserAuth().getCurrentUser();
      user = currentUser;
      user.mobileNumber = phoneNumber;
      user.authId = _userId;
      bool success =
          await userDAO.updateData(user, where: "ID == '${currentUser.ID}'");
      print(success);
      if (success) {
        return Future.value(success);
      }
      return Future.value(success);
    }
    return false;
  }

  Future<bool> saveUserInLocalDb(UserResponseApi result) async {
    UserDAO userDAO = UserDAO();
    UserEntity currentUser = await UserAuth().getCurrentUser();
    UserEntity newUser = UserEntity().convertToUserEntity(result);
    newUser.selectedContactId = "me";
    bool a =
        await userDAO.updateData(newUser, where: "ID == '${currentUser.ID}'");
    return a;
  }

  Future<bool> validateOtpCode(String otp, BuildContext context) async {
    try {
      userModel = PhoneNumberRequestApi(mobileNumber: this.phoneNumber);

      APIRequests request = APIRequests();
      print("here");
      OtpVerificationResponseApi result = await request.execute(
          APIConstants.BASE_URL + APIConstants.API_OTP_VERIFICATION + "/$otp",
          context,
          authToken: "",
          body: jsonEncode(userModel.toMap(withoutUniqueIDs: false)),
          responseClass: OtpVerificationResponseApi(),
          apiMethod: ApiMethod.PUT);

      if (result.errorBody == null) {
        _userId = result.Id;
        bool isSuccess = await _saveUserAccessToken(result.token.access_token);
        isVerified = true;
        if (result.user != null) {
          cloudUser = result.user;
        }
        return Future.value(isSuccess);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> _saveUserAccessToken(String accessToken) async {
    UserDAO userDAO = UserDAO();
    UserEntity user = UserEntity();
    await UserAuth().renewUser();
    UserEntity currentUser = await UserAuth().getCurrentUser();
    user = currentUser;
    user.accessToken = accessToken;
    bool success =
        await userDAO.updateData(user, where: "ID == '${currentUser.ID}'");
    print(success);
    if (success) {
      return Future.value(success);
    }
    return Future.value(success);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/models/response/visitor_token_response.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/api_error_body.dart';

enum ApiMethod { GET, PUT, POST, DELETE, PATCH }

class APIRequests {
  static final _instance = APIRequests._internal();

//  final HttpClient _httpClient = HttpClient();

  factory APIRequests() {
    return _instance;
  }

  APIRequests._internal() {
    //set default timeouts for http client to use inside entire app
//    _httpClient.connectionTimeout =
//        const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);
//    _httpClient.idleTimeout =
//        const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);
  }

  Future<bool> _isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  Future<T> execute<T>(String url, BuildContext context,
      {String authToken,
        String body,
        ApiBaseModel<T> responseClass,
        ApiMethod apiMethod}) async {
    try {
      ///checking network availability
      if (!await _isNetworkAvailable()) {
//        if (PopupDialogs.isShowingLodingDialog) {
//          PopupDialogs.isShowingLodingDialog = false;
//          Navigator.pop(context);
//        }
        if (context != null)
          PopupDialogs.showSimplePopDialog(
              context,
              'Connection issue'.tr(),
              'No internet connection. Please make sure WiFI or mobile data is on and try again.'
                  .tr());

        return Future.error(null);
      }

      final HttpClient _httpClient = HttpClient();
      _httpClient.connectionTimeout =
      const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);
      _httpClient.idleTimeout =
      const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);

      HttpClientRequest request;

      // identify the API method type
      switch (apiMethod) {
        case ApiMethod.GET:
          request = await _httpClient.getUrl(Uri.parse(url));
          break;
        case ApiMethod.PUT:
          request = await _httpClient.putUrl(Uri.parse(url));
          break;
        case ApiMethod.POST:
          request = await _httpClient.postUrl(Uri.parse(url));
          break;
        case ApiMethod.DELETE:
          request = await _httpClient.deleteUrl(Uri.parse(url));
          break;
        case ApiMethod.PATCH:
          request = await _httpClient.patchUrl(Uri.parse(url));
          break;
      }

      //add headers to the request
      request.headers.set(
          HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_CONTENT,
          HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_CONTENT_JSON);
      //add authtoken to request header except otp get api and otp verify api
      if (url !=
          APIConstants.BASE_URL +
              APIConstants.API_OTP +
              HttpRequestParameters.OTP_REQUEST_URL_PARAM &&
          !url.contains(
              APIConstants.BASE_URL + APIConstants.API_OTP_VERIFICATION)) {
        try {
          UserEntity currentUser = await UserAuth().getCurrentUser();
          if (currentUser != null && currentUser.accessToken != null)
            request.headers.set(
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH,
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH_BEARER +
                    currentUser.accessToken);
        } catch (i) {
          request.headers.set(
              HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH,
              HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH_BEARER +
                  authToken);
        }
      } else {
        // For otp verification - Use visitor Token
        VisitorTokenResponseApi responseApi = await execute(
            APIConstants.BASE_URL + APIConstants.API_VISITOR, context,
            apiMethod: ApiMethod.POST,
            authToken: "",
            responseClass: VisitorTokenResponseApi());

        if (responseApi != null) {
          if (responseApi.visitorToken != null) {
            request.headers.set(
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH,
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH_BEARER +
                    responseApi.visitorToken);
          }
        }
      }

      print('api base request $url');
      print('api base request body $body');

      //add body to the request
      if (body != null && body.isNotEmpty) {
        request.add(utf8.encode(body));
      }

      //
      if (body != null)
        print('api base request data ${utf8.decode(utf8.encode(body))}');
      HttpClientResponse response = await request.close();
      String res = await response.transform(utf8.decoder).join();
      print('api url : ' + url);
      print('api base reponse :  $res');
      if (res == null) {
        res = '{"message": "operation finished"}';
      }

      // If the server send a error
      if (response.statusCode != APIConstants.SUCCESS_CODE &&
          response.statusCode != APIConstants.CREATED_CODE) {
        print("Status Code : Error : " + response.statusCode.toString());
        if (json.decode(res) is Map) {
          Map<String, dynamic> map = json.decode(res) as Map;
          if (map["message"] is List) {
            responseClass.errorBody = new ApiErrorBody();
            responseClass.errorBody.messages = Map();
            responseClass.errorBody.messages["english"] =
            "Something Went wrong. Please Try Again!";
          } else {
            responseClass.errorBody = ApiErrorBody().toClass(map);
          }
          return Future.value(responseClass.toClass(map));
        }
      }

      // Success Status
      else if (response.statusCode == APIConstants.SUCCESS_CODE) {
        print("Status Code : Success");
        // Result As Map
        if (json.decode(res) is Map) {
          Map<String, dynamic> map = json.decode(res) as Map;
          return Future.value(responseClass.toClass(map));
        }
        // Result As a List
        else if (json.decode(res) is List) {
          print(List);
          List<dynamic> list = json.decode(res) as List;
          return Future.value(responseClass.listToClass(list));
        }
        // No Result
        else {
          return Future.value(null);
        }
      }

      // Created Status
      else if (response.statusCode == APIConstants.CREATED_CODE) {
        print("Status Code : Created");
        if (res.isEmpty) {
          Map<String, dynamic> map = Map();
          map["statusCode"] = response.statusCode;
          return Future.value(responseClass.toClass(map));
        } else if (json.decode(res) is Map) {
          Map<String, dynamic> map = json.decode(res) as Map;
          map["statusCode"] = response.statusCode;
          return Future.value(responseClass.toClass(map));
        } else {
          return Future.value(null);
        }
      }

      return Future.value(null);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<List<T>> getList<T>(String url, BuildContext context,
      {String authToken, String body, ApiBaseModel<T> responseClass, ApiMethod apiMethod}) async {
    try {

      // identify the API method type
      ///checking network availability
      if (!await _isNetworkAvailable()) {
//        if (PopupDialogs.isShowingLodingDialog) {
//          PopupDialogs.isShowingLodingDialog = false;
//          Navigator.pop(context);
//        }
        if (context != null)
          PopupDialogs.showSimplePopDialog(
              context,
              'Connection issue'.tr(),
              'No internet connection. Please make sure WiFI or mobile data is on and try again.'
                  .tr());

        return Future.error(null);
      }

      final HttpClient _httpClient = HttpClient();
      _httpClient.connectionTimeout =
      const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);
      _httpClient.idleTimeout =
      const Duration(seconds: HttpConstants.HTTP_CONSTANTS_DEF_TIMEOUT);

      HttpClientRequest request;

      if (apiMethod == null){
        request = await _httpClient.getUrl(Uri.parse(url));
      }
      else {
        switch (apiMethod) {
          case ApiMethod.GET:
            request = await _httpClient.getUrl(Uri.parse(url));
            break;
          case ApiMethod.PUT:
            request = await _httpClient.putUrl(Uri.parse(url));
            break;
          case ApiMethod.POST:
            request = await _httpClient.postUrl(Uri.parse(url));
            break;
          case ApiMethod.DELETE:
            request = await _httpClient.deleteUrl(Uri.parse(url));
            break;
          case ApiMethod.PATCH:
            request = await _httpClient.patchUrl(Uri.parse(url));
            break;
        }
      }

      //add headers to the request
      request.headers.set(
          HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_CONTENT,
          HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_CONTENT_JSON);
      //add authtoken to request header except otp get api and otp verify api
      if (url !=
          APIConstants.BASE_URL +
              APIConstants.API_OTP +
              HttpRequestParameters.OTP_REQUEST_URL_PARAM ||
          url.contains(
              APIConstants.BASE_URL + APIConstants.API_OTP_VERIFICATION)) {
        try {
          UserEntity currentUser = await UserAuth().getCurrentUser();
          if (currentUser != null && currentUser.accessToken != null)
            request.headers.set(
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH,
                HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH_BEARER +
                    currentUser.accessToken);
        } catch (i) {
          request.headers.set(
              HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH,
              HttpAPIHeaderConstants.HTTP_API_HEAD_CONSTANTS_AUTH_BEARER +
                  authToken);
        }
      }

      print(request.headers.toString());

      print('api base request $url');
      debugPrint('api base request body $body');

      //add body to the request
      if (body != null && body.isNotEmpty) {
        request.headers.contentLength = utf8
            .encode(body)
            .length;
        request.add(utf8.encode(body));
      }

      //
      if (body != null)
        print('api base request data ${utf8.decode(utf8.encode(body))}');
      HttpClientResponse response = await request.close();
      String res = await response.transform(utf8.decoder).join();
      print('api base reponse : $res');
      debugPrint('response lenght : $res');
      if (res == null) {
        res = '{"message": "operation finished"}';
      }

      // If the server send a error
      if (response.statusCode != APIConstants.SUCCESS_CODE && response.statusCode != APIConstants.CREATED_CODE) {
        print("Status Code : Error : " + response.statusCode.toString());
        if (json.decode(res) is Map) {
          Map<String, dynamic> map = json.decode(res) as Map;
          responseClass.errorBody.toClass(map);
          List<T> list = List<T>();
          list.add(responseClass.toClass(map));
          return Future.value(list);
        }
      }

      // Success Status
      else if (response.statusCode == APIConstants.SUCCESS_CODE || response.statusCode == APIConstants.CREATED_CODE) {
        print("Status Code : Success");
        // Result As Map - Pagination
        if (json.decode(res) is List &&
            ((json.decode(res) as List<dynamic>)[0] as Map<String, dynamic>)
                .containsKey("data")) {
          Map<String, dynamic> map =
          ((json.decode(res) as List<dynamic>)[0] as Map<String, dynamic>);
          print(map["metadata"]);
          List<dynamic> list = map["data"] as List<dynamic>;
          List<dynamic> metaData = map["data"] as List<dynamic>;
          int pages = 0;
          int total = 0;
          for (Map<String, dynamic> map in list) {
            if (map.containsKey("page")) pages = map["page"];
            if (map.containsKey("total")) total = map["total"];
          }
          print(list);

          List<T> result = List<T>();
          for (Map<String, dynamic> map in list) {
            map["pages"] = pages;
            map["total"] = total;
            result.add(responseClass.toClass(map));
          }

          // list of data
          return Future.value(result);
        }
        // Result As a List
        else if (json.decode(res) is List) {
          print("Result As a List");
          List<dynamic> list =
          (json.decode(res) as List<dynamic>);
          List<T> result = List<T>();
          list.forEach((source) {
            Map<String, dynamic> response = source;
            result.add(responseClass.toClass(response));
          });
          print(result.length);
          return Future.value(result);
        }
        // No Result
        else {
          return Future.value(null);
        }
      }

      return Future.value(null);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }
}

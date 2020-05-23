import 'package:food_deliver/src/api/models/response/user_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OtpVerificationResponseApi extends ApiBaseModel<OtpVerificationResponseApi>{
  String message;
  AccessTokenResponseApi token;
  String Id;
  UserResponseApi user;

  @override
  OtpVerificationResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('message')) this.message = map['message'];
    if (map.containsKey('token')) this.token = AccessTokenResponseApi().toClass(map['token']);

    if(map.containsKey('user')){
      if (map.containsKey('_id')) this.Id = map['_id'];
    }

    if (map.containsKey('user')) {
      Map<String, dynamic> userMap = map['user'];
      if (userMap != null) {
        if (userMap.containsKey('_id')) this.Id = userMap['_id'];
        this.user = UserResponseApi().toClass(userMap);
      }
    }


    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.message.isInvalid()) map['message'] = this.message;
    if (this.token != null) map['token'] = this.token.toMap();
    if (this.Id != null) map['_id'] = this.Id;
    return map;
  }

}

class AccessTokenResponseApi extends ApiBaseModel<AccessTokenResponseApi>{
  String access_token;

  @override
  AccessTokenResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('access_token')) this.access_token = map['access_token'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.access_token.isInvalid()) map['access_token'] = this.access_token;
    return map;
  }

}


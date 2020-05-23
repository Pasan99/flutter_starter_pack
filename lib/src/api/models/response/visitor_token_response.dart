import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class VisitorTokenResponseApi extends ApiBaseModel<VisitorTokenResponseApi>{
  String visitorToken;

  @override
  VisitorTokenResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('visitor_token')) this.visitorToken = map['visitor_token'];


    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.visitorToken.isInvalid()) map['visitor_token'] = this.visitorToken;
    return map;
  }

}


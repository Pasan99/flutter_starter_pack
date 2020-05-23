import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class CancelOrderRequestApi extends ApiBaseModel<CancelOrderRequestApi> {
  String orderId;
  String reason;

  CancelOrderRequestApi(
      {this.orderId, this.reason});


  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('orderId')) this.orderId = map['orderId'];
    if (map.containsKey('reason')) this.reason = map['reason'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.orderId.isInvalid()) map['orderId'] = this.orderId;
    if (!this.reason.isInvalid()) map['reason'] = this.reason;
    return map;
  }
}

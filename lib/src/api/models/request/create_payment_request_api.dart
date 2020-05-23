import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class CreatePaymentRequestApi extends ApiBaseModel<CreatePaymentRequestApi>{
  String orderId;
  String userId;
  double paymentAmount;
  String referenceId;
  String status;
  bool isDeleted;

  CreatePaymentRequestApi({@required this.orderId, @required this.userId,
    @required this.paymentAmount, @required this.referenceId,  @required this.status,
    @required this.isDeleted,});

  @override
  CreatePaymentRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('orderId')) this.orderId = map['orderId'];
    if (map.containsKey('userId')) this.userId = map['userId'];
    if (map.containsKey('referenceId')) this.referenceId = map['referenceId'];
    if (map.containsKey('paymentAmount')) this.paymentAmount = map['paymentAmount'];
    if (map.containsKey('status')) this.status = map['status'];
    if (map.containsKey('isDeleted')) this.isDeleted = map['isDeleted'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.orderId.isInvalid()) map['orderId'] = this.orderId;
    if (!this.userId.isInvalid()) map['userId'] = this.userId;
    if (!this.referenceId.isInvalid()) map['referenceId'] = this.referenceId;
    if (!this.status.isInvalid()) map['status'] = this.status;
    if (this.isDeleted != null ) map['isDeleted'] = this.isDeleted;
    if (this.paymentAmount != null) map['paymentAmount'] = this.paymentAmount;
    return map;
  }

}
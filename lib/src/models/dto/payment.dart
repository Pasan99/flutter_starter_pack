
import 'dart:ffi';

class Payment {
  String orderId;
  String userId;
  Float paymentAmount;
  String referenceId;
  String status;
  String isDeleted;

  Payment.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        userId = json['userId'],
        paymentAmount = json['paymentAmount'],
        referenceId = json['referenceId'],
        status = json['status'],
        isDeleted = json['isDeleted'];
}

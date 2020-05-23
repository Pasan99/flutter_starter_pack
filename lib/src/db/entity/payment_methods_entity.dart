import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/api/models/response/validate_order_response.dart';

import 'base_entity.dart';

class PaymentMethodEntity extends BaseEntity<PaymentMethodEntity> {
  String ID;
  String name; //name map

  PaymentMethodEntity({this.ID, this.name});

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID TEXT PRIMARY KEY' +
        ', name TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  PaymentMethodEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('name')) this.name = map['name'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (name != null) map['name'] = this.name;
    return map;
  }

  List<PaymentMethodEntity> convertToPaymentMethod(
      CheckoutTransactionResponseApi orderResponseApi) {
    if (orderResponseApi.storeDetails == null ) return null;
    return orderResponseApi.storeDetails.paymentMethods.map((payment) {
      print(payment);
      if (payment.toLowerCase() == "cash") {
        return PaymentMethodEntity(ID: "cash", name: "Cash on Delivery");
      }
      else{
        return PaymentMethodEntity(ID: "card", name: "Credit / Debit Card");
      }
    }).toList();
  }
}

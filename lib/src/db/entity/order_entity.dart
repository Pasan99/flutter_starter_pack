import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OrderEntity extends BaseEntity<OrderEntity> {
  int ID;
  int orderId;
  String orderDate;
  String items; //jsonEncoded(List<OrderItem>)
  String storeId;
  String status;

//  String contactId;
  String cancellationReason;
  String paymentMethod;
  double transactionTotal;
  String fees; //jsonEncoded(List<Fees>)
  String assignedDateAndTime;
  String pickedUpDateAndTime;
  String deliveryStartedDateAndTime;
  String deliveryCompletedDateAndTime;

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', orderId INTEGER' +
        ', orderDate TEXT' +
        ', items TEXT' +
        ', storeId TEXT' +
        ', status TEXT' +
        ', cancellationReason TEXT' +
        ', paymentMethod TEXT' +
        ', transactionTotal REAL' +
        ', fees TEXT' +
        ', assignedDateAndTime TEXT' +
        ', pickedUpDateAndTime TEXT' +
        ', deliveryStartedDateAndTime TEXT' +
        ', deliveryCompletedDateAndTime TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  OrderEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('orderId')) this.orderId = map['orderId'];
    if (map.containsKey('orderDate')) this.orderDate = map['orderDate'];
    if (map.containsKey('items')) this.items = map['items'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('status')) this.status = map['status'];
    if (map.containsKey('cancellationReason'))
      this.cancellationReason = map['cancellationReason'];
    if (map.containsKey('paymentMethod'))
      this.paymentMethod = map['paymentMethod'];
    if (map.containsKey('transactionTotal'))
      this.transactionTotal = map['transactionTotal'];
    if (map.containsKey('fees')) this.fees = map['fees'];
    if (map.containsKey('assignedDateAndTime'))
      this.assignedDateAndTime = map['assignedDateAndTime'];
    if (map.containsKey('pickedUpDateAndTime'))
      this.pickedUpDateAndTime = map['pickedUpDateAndTime'];
    if (map.containsKey('deliveryStartedDateAndTime'))
      this.deliveryStartedDateAndTime = map['deliveryStartedDateAndTime'];
    if (map.containsKey('deliveryCompletedDateAndTime'))
      this.deliveryCompletedDateAndTime = map['deliveryCompletedDateAndTime'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.orderId != null) map['orderId'] = this.orderId;
    if (!this.orderDate.isInvalid()) map['orderDate'] = this.orderDate;
    if (!this.items.isInvalid()) map['items'] = this.items;
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (!this.status.isInvalid()) map['status'] = this.status;
    if (!this.cancellationReason.isInvalid())
      map['cancellationReason'] = this.cancellationReason;
    if (!this.paymentMethod.isInvalid())
      map['paymentMethod'] = this.paymentMethod;
    if (this.transactionTotal != null)
      map['transactionTotal'] = this.transactionTotal;
    if (!this.fees.isInvalid()) map['fees'] = this.fees;
    if (!this.assignedDateAndTime.isInvalid())
      map['assignedDateAndTime'] = this.assignedDateAndTime;
    if (!this.pickedUpDateAndTime.isInvalid())
      map['pickedUpDateAndTime'] = this.pickedUpDateAndTime;
    if (!this.deliveryStartedDateAndTime.isInvalid())
      map['deliveryStartedDateAndTime'] = this.deliveryStartedDateAndTime;
    if (!this.deliveryCompletedDateAndTime.isInvalid())
      map['deliveryCompletedDateAndTime'] = this.deliveryCompletedDateAndTime;
    return map;
  }

  OrderEntity convertToOrderEntity(Order order) {
    if (order == null) return null;
    OrderEntity orderEntity = OrderEntity();
    if (order.orderId != null) orderEntity.orderId = order.orderId;
    if (order.items != null) {}
    if (order.transactionTotal != null)
      orderEntity.transactionTotal = order.transactionTotal;
    if (!order.storeId.isInvalid()) orderEntity.storeId = order.storeId;
    if (!order.paymentMethod.isInvalid())
      orderEntity.paymentMethod = order.paymentMethod;
    return orderEntity;
  }
}

import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class CreateOrderRequestApi extends ApiBaseModel<CreateOrderRequestApi>{
  String userId;
  List<OrderItemRequestApi> items;
  String storeId;
  String contactId;
  String paymentMethod;
  double transactionTotal;
  List<FeesRequestApi> fees;
  String note;

//  CreateOrderRequestApi({ @required this.userId, @required this.items, @required this.storeId,
//  @required this.contactId, @required this.paymentMethod, @required this.transactionTotal, this.fees, @required this.note});

  @override
  CreateOrderRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('userId')) this.userId = map['userId'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('contactId'))
      this.contactId = map['contactId'];
    if (map.containsKey('paymentMethod')) this.paymentMethod = map['paymentMethod'];
    if (map.containsKey('transactionTotal')) this.transactionTotal = map['transactionTotal'];
    if (map.containsKey('note')) this.note = map['note'];

    if (map.containsKey('items')) {
      items = List();
      List<dynamic> jsonArr = map['items'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          items.add(landmark);
        });
      }
    }

    if (map.containsKey('fees')) {
      fees = List();
      List<dynamic> jsonArr = map['fees'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          fees.add(landmark);
        });
      }
    }


    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.userId.isInvalid()) map['userId'] = this.userId;
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (!this.contactId.isInvalid())
      map['contactId'] = this.contactId;
    if (!this.paymentMethod.isInvalid()) map['paymentMethod'] = this.paymentMethod;
    if (this.transactionTotal != null) map['transactionTotal'] = this.transactionTotal;
    if (!this.note.isInvalid()) map['note'] = this.note;

    if (!this.fees.isInvalid()) {
      var newFees = fees.map((fee)=> fee.toMap()).toList();
      map['fees'] = newFees;
    }
    if (!this.items.isInvalid()) {
      var newItems = items.map((item)=> item.toMap()).toList();
      map['items'] = newItems;
    }

    return map;
  }

}

class OrderItemRequestApi extends ApiBaseModel<OrderItemRequestApi> {
  String packageId;
  double qty;
  double perPackagePrice;
  double total;

  @override
  OrderItemRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('packageId')) this.packageId = map['packageId'];
    if (map.containsKey('qty')) this.qty = map['qty'];
    if (map.containsKey('perPackagePrice')) this.perPackagePrice = (map['perPackagePrice'] as int).toDouble();
    if (map.containsKey('total')) this.total = (map['total'] as int).toDouble();

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.packageId.isInvalid()) map['packageId'] = this.packageId;
    if (qty!= null) map['qty'] = this.qty;
    if (total != null) map['total'] = this.total;
    if (perPackagePrice != null) map['perPackagePrice'] = this.perPackagePrice;

    return map;
  }

  OrderItemRequestApi toOrderItem(CartItemEntity cartItemEntity){
    OrderItemRequestApi orderItem = new OrderItemRequestApi();
    orderItem.packageId = cartItemEntity.product.Id;
    orderItem.qty = cartItemEntity.quantity;
    orderItem.perPackagePrice = cartItemEntity.product.productAmount;
    orderItem.total = cartItemEntity.total;
    return orderItem;
  }

}

class FeesRequestApi extends ApiBaseModel<FeesRequestApi> {
  String feeId;
  double amount;

  @override
  FeesRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('feeId')) this.feeId = map['feeId'];
    if (map.containsKey('amount')) this.amount = (map['amount'] as int).toDouble();

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.feeId.isInvalid()) map['feeId'] = this.feeId;
    if (amount != null) map['amount'] = this.amount;
    return map;
  }

  FeesRequestApi toFeeRequest(FeesEntity feesEntity){
    FeesRequestApi feesRequestApi = new FeesRequestApi();
    feesRequestApi.feeId = feesEntity.feeID;
    feesRequestApi.amount = feesEntity.finalAmount;
    return feesRequestApi;
  }

}

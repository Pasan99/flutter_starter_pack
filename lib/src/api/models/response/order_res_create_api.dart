import 'package:food_deliver/src/api/models/response/package_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
class OrderResponsePaginationApi
    extends ApiBaseModel<OrderResponsePaginationApi> {
  List<OrderResponsePaginationApi> itemList;
  List<dynamic> metadata;
  int total;
  int page;
  List<Order> data;
  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('metadata')) this.metadata = map['metadata'];
    if (this.metadata != null && this.metadata.isNotEmpty) {
      if (this.metadata[0].containsKey('total'))
        this.total = this.metadata[0]['total'];
      if (this.metadata[0].containsKey('page'))
        this.page = this.metadata[0]['page'];
    }
    if (map.containsKey('data')) {
      this.data = List();
      List<dynamic> jsonArr = map['data'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((order) {
          this.data.add(Order().toClass(order));
        });
      }
    }
    return this;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    return null;
  }
  @override
  OrderResponsePaginationApi listToClass(List<dynamic> array) {
    if (array.isInvalid()) return null;
    OrderResponsePaginationApi api = OrderResponsePaginationApi();
    api.itemList = List();
    array.forEach((item) {
      if (item != null && item is Map && item.isNotEmpty)
        api.itemList.add(OrderResponsePaginationApi().toClass(item));
    });
    return api;
  }
}
class Order extends ApiBaseModel<Order> {
  String _id;
  int orderId;
  String orderDate;
  List<Item> items;
  String storeId;
  String paymentMethod;
  double transactionTotal;
  List<dynamic> fees;
  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('orderId')) this.orderId = map['orderId'];
    if (map.containsKey('orderDate')) this.orderDate = map['orderDate'];
    if (map.containsKey('items')) {
      this.items = List();
      List<dynamic> jsonArray = map['items'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((item) {
          this.items.add(Item().toClass(item));
        });
      }
    }
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('paymentMethod'))
      this.paymentMethod = map['paymentMethod'];
    if (map.containsKey('transactionTotal')) {
      if (map['transactionTotal'] is int)
      this.transactionTotal = (map['transactionTotal'] as int).toDouble();
      else if (map['transactionTotal'] is double)
        this.transactionTotal = map['transactionTotal'];
    }
    return this;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (this.orderId != null) map['orderId'] = this.orderId;
    if (!this.orderDate.isInvalid()) map['orderDate'] = this.orderDate;
    if (!this.items.isInvalid()) {
      List<dynamic> list = List();
      this.items.forEach((item) {
        list.add(item.toMap());
      });
      map['items'] = list;
    }
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (!this.paymentMethod.isInvalid())
      map['paymentMethod'] = this.paymentMethod;
    if (this.transactionTotal != null)
      map['transactionTotal'] = this.transactionTotal;
    return map;
  }
  String get id => _id;
}
class Item extends ApiBaseModel<Item> {
  String _id;
  String packageId;
  int qty;
  double perPackagePrice;
  double total;
  String updatedAt;
  String createdAt;
  List<PackageResponseApi> package;
  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('packageId')) this.packageId = map['packageId'];
    if (map.containsKey('qty')) this.qty = map['qty'];
    if (map.containsKey('perPackagePrice')) this.perPackagePrice = (map['perPackagePrice'] as int).toDouble();
    if (map.containsKey('total')) this.total = (map['total'] as int).toDouble();
    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];
    if (map.containsKey('package')) {
      this.package = List();
      List<dynamic> jsonArr = map['package'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          this.package.add(PackageResponseApi().toClass(package));
        });
      }
    }
    return this;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (!this.packageId.isInvalid()) map['packageId'] = this.packageId;
    if (this.qty != null) map['qty'] = this.qty;
    if (this.perPackagePrice != null)
      map['perPackagePrice'] = this.perPackagePrice;
    if (this.total != null) map['total'] = this.total;
    if (!this.updatedAt.isInvalid()) map['updatedAt'] = this.updatedAt;
    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;
    if (!this.package.isInvalid()) {
      List<dynamic> list = List();
      this.package.forEach((item) {
        list.add(item.toMap());
      });
      map['package'] = list;
    }
    return map;
  }
  String get id => _id;
}
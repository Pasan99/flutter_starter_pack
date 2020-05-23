import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OrderResponsePaginationApi
    extends ApiBaseModel<OrderResponsePaginationApi> {
  List<OrderResponsePaginationApi> itemList;

  List<dynamic> metadata;
  int total = 1;
  int page = 1;
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
      List<dynamic> jsonArr = map['data'] as List<dynamic>;
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
  double feeTotal = 0;
  String _id;
  int orderId;
  List<Item> items;
  String storeId;
  String convertedName = "";
  Map<String, dynamic> storeName;
  String status;
  String cancellationReason;
  String contactId;
  String contactName;
  String nicNumber;

//  CityName cityName;
  Map<String, dynamic> cityName;
  String mainRoad;
  String street;
  String houseNo;
  List<dynamic> landMarks;
  String contactNumber;
  String paymentMethod;
  double transactionTotal;
  List<FeeApi> fees;
  String assignedDateAndTime;
  String createdAt;
  String pickedUpDateAndTime;
  String deliveryStartedDateAndTime;
  String deliveryCompletedDateAndTime;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('orderId')) this.orderId = map['orderId'];

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
    if (map.containsKey('storeName')) this.storeName = map['storeName'];
    if (map.containsKey('status')) this.status = map['status'];
    if (map.containsKey('cancellationReason'))
      this.cancellationReason = map['cancellationReason'];
    if (map.containsKey('contactId')) this.contactId = map['contactId'];
    if (map.containsKey('contactName')) this.contactName = map['contactName'];
    if (map.containsKey('nicNumber')) this.nicNumber = map['nicNumber'];
    if (map.containsKey('cityName')) this.cityName = map['cityName'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('landMarks')) this.landMarks = map['landMarks'];
    if (map.containsKey('contactNumber'))
      this.contactNumber = map['contactNumber'];
    if (map.containsKey('paymentMethod'))
      this.paymentMethod = map['paymentMethod'];
    if (map.containsKey('transactionTotal')) {
      if (map['transactionTotal'] is int) {
        this.transactionTotal = (map['transactionTotal'] as int).toDouble();
      }
      else if (map['transactionTotal'] is double){
        this.transactionTotal = map['transactionTotal'];
      }
    }

    if (map.containsKey('fees')) {
      this.fees = List();
      List<dynamic> jsonArray = map['fees'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((fee) {
          this.fees.add(FeeApi().toClass(fee));
        });
      }
    }

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
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (this.orderId != null) map['orderId'] = this.orderId;

    if (!this.items.isInvalid()) {
      List<dynamic> list = List();
      this.items.forEach((item) {
        list.add(item.toMap());
      });
      map['items'] = list;
    }

    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (this.storeName != null) map['storeName'] = this.storeName;
    if (!this.status.isInvalid()) map['status'] = this.status;
    if (!this.cancellationReason.isInvalid())
      map['cancellationReason'] = this.cancellationReason;
    if (!this.contactId.isInvalid()) map['contactId'] = this.contactId;
    if (!this.contactName.isInvalid()) map['contactName'] = this.contactName;
    if (!this.nicNumber.isInvalid()) map['nicNumber'] = this.nicNumber;
    if (this.cityName != null) map['cityName'] = this.cityName;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;
    if (!this.landMarks.isInvalid()) map['landMarks'] = this.landMarks;
    if (!this.contactNumber.isInvalid())
      map['contactNumber'] = this.contactNumber;
    if (!this.paymentMethod.isInvalid())
      map['paymentMethod'] = this.paymentMethod;
    if (this.transactionTotal != null)
      map['transactionTotal'] = this.transactionTotal;

    if (!this.fees.isInvalid()) {
      List<dynamic> list = List();
      this.fees.forEach((fee) {
        list.add(fee.toMap());
      });
      map['fees'] = list;
    }

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

  String get id => _id;
}

class Item extends ApiBaseModel<Item> {
  String _id;
  String packageId;
  String convertedPackageName;
  Map<String, dynamic> packageName;
  List<PackageApi> packageItems;
  int packageQty;
  double perPackagePrice;
  double total;
  String updatedAt;
  String createdAt;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('packageId')) this.packageId = map['packageId'];
    if (map.containsKey('packageName')) this.packageName = map['packageName'];
    if (map.containsKey('packageQty')) this.packageQty = map['packageQty'];
    if (map.containsKey('perPackagePrice')) {
      if (map['perPackagePrice'] is int) {
        this.perPackagePrice = (map['perPackagePrice'] as int).toDouble();
      }
      else if (map['perPackagePrice'] is double){
        this.perPackagePrice = map['perPackagePrice'];
      }
    }
    if (map.containsKey('total')) {
      if (map['total'] is int) {
        this.total = (map['total'] as int).toDouble();
      }
      else if (map['total'] is double){
        this.total = map['total'];
      }
    }
    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];

    if (map.containsKey('packageItems')) {
      this.packageItems = List();
      List<dynamic> jsonArr = map['packageItems'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          this.packageItems.add(PackageApi().toClass(package));
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
    if (this.packageName != null) map['packageName'] = this.packageName;
    if (this.packageQty != null) map['packageQty'] = this.packageQty;
    if (this.perPackagePrice != null)
      map['perPackagePrice'] = this.perPackagePrice;
    if (this.total != null) map['total'] = this.total;
    if (!this.updatedAt.isInvalid()) map['updatedAt'] = this.updatedAt;
    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;

    if (!this.packageItems.isInvalid()) {
      List<dynamic> list = List();
      this.packageItems.forEach((item) {
        list.add(item.toMap());
      });
      map['packageItems'] = list;
    }
    return map;
  }

  String get id => _id;
}

class CityName extends ApiBaseModel<CityName> {
  String sinhala;
  String english;
  String tamil;

  @override
  CityName toClass(Map<String, dynamic> map) {
    if (map.containsKey('sinhala')) this.sinhala = map['sinhala'];
    if (map.containsKey('english')) this.english = map['english'];
    if (map.containsKey('tamil')) this.tamil = map['tamil'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.sinhala.isInvalid()) map['sinhala'] = this.sinhala;
    if (!this.english.isInvalid()) map['english'] = this.english;
    if (!this.tamil.isInvalid()) map['tamil'] = this.tamil;
    return map;
  }
}

class FeeApi extends ApiBaseModel<FeeApi> {
  String _id;
  String feeId;
  Map<String, dynamic> names;
  String name;
  double amount;
  String updatedAt;
  String createdAt;

  String get id => _id;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('feeId')) this.feeId = map['feeId'];
    if (map.containsKey('name')) this.names = map['name'];
    if (map.containsKey('amount')) {
      if (map['amount'] is int) {
        this.amount = (map['amount'] as int).toDouble();
      }
      else if (map['amount'] is double){
        this.amount = map['amount'];
      }
    }
    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (!this.feeId.isInvalid()) map['feeId'] = this.feeId;
    if (this.amount != null) map['amount'] = this.amount;
    if (!this.updatedAt.isInvalid()) map['updatedAt'] = this.updatedAt;
    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;
    return map;
  }
}

class PackageApi extends ApiBaseModel<PackageApi> {
  String Id;
  Map<String, dynamic> productName;
  String product = "";
  String qty;
  String updatedAt;
  String createdAt;

  @override
  PackageApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('productName')) this.productName = map['productName'];
    if (map.containsKey('qty')) this.qty = map['qty'];
    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.productName != null) map['productName'] = this.productName;
    if (!this.qty.isInvalid()) map['qty'] = this.qty;
    if (!this.updatedAt.isInvalid()) map['updatedAt'] = this.updatedAt;
    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;

    return map;
  }
}

import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class CheckoutTransactionResponseApi
    extends ApiBaseModel<CheckoutTransactionResponseApi> {
  // ignore: non_constant_identifier_names
  String Id;
  List<ProductStockResponseApi> productsStocks;
  SchedulerResponseApi scheduler;
  StoreDetailsResponseApi storeDetails;

  @override
  CheckoutTransactionResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('productsStocks')) {
      this.productsStocks = List();
      List<dynamic> jsonArray = map['productsStocks'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((product) {
          this.productsStocks.add(ProductStockResponseApi().toClass(product));
        });
      }
    }
    if (map.containsKey('scheduler'))
      this.scheduler = SchedulerResponseApi().toClass(map['scheduler']);
    if (map.containsKey('storeDetails'))
      this.storeDetails =
          StoreDetailsResponseApi().toClass(map['storeDetails']);

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (!this.productsStocks.isInvalid()) {
      List<dynamic> list = List();
      this.productsStocks.forEach((product) {
        list.add(product.toMap());
      });
      map['productsStocks'] = list;
    }
    if (this.scheduler != null) map['scheduler'] = this.scheduler.toMap();
    if (this.storeDetails != null) map['storeDetails'] = this.storeDetails.toMap();
    return map;
  }
}

class ProductStockResponseApi extends ApiBaseModel<ProductStockResponseApi> {
  // ignore: non_constant_identifier_names
  String Id;
  String location;
  num stock;

  @override
  ProductStockResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('location')) this.location = map['location'];
    if (map.containsKey('stock')) this.stock = map['stock'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (!this.location.isInvalid()) map['location'] = this.location;
    if (this.stock != null) map['stock'] = this.stock;
    return map;
  }
}

class SchedulerResponseApi extends ApiBaseModel<SchedulerResponseApi> {
  num draftExpireTime;
  num draftExpireBuffer;

  @override
  SchedulerResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('draftExpireTime'))
      this.draftExpireTime = map['draftExpireTime'];
    if (map.containsKey('draftExpireBuffer'))
      this.draftExpireBuffer = map['draftExpireBuffer'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.draftExpireTime != null)
      map['draftExpireTime'] = this.draftExpireTime;
    if (this.draftExpireBuffer != null)
      map['draftExpireBuffer'] = this.draftExpireBuffer;
    return map;
  }
}

class StoreDetailsResponseApi extends ApiBaseModel<StoreDetailsResponseApi> {
  // ignore: non_constant_identifier_names
  String Id;
  List<dynamic> paymentMethods;
  String cashierId;

  @override
  StoreDetailsResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('paymentMethods'))
      this.paymentMethods = map['paymentMethods'];
    if (map.containsKey('cashierId')) this.cashierId = map['cashierId'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (!this.paymentMethods.isInvalid())
      map['paymentMethods'] = this.paymentMethods;
    if (this.cashierId != null) map['cashierId'] = this.cashierId;
    return map;
  }
}

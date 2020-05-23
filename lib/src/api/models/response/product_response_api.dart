import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
class ProductResponseApi extends ApiBaseModel<ProductResponseApi> {
  String Id;
  String productName;
  Map<String, dynamic> productNames;
  String image;
  String storeId;
  num amount;
  String description;
  num stock;
  List<num> qntIncrements;
  UnitOfMeasure unitOfMeasure;
  Brand brand;
  Category category;
  List<Fee> fees;


  String storeName;
  String cityName;

  Map<String, dynamic> storeNames;
  Map<String, dynamic> cityNames;

  num maxOrderAmount;

  int pages;
  int total;

  ProductResponseApi({this.stock, this.Id});

  @override
  ProductResponseApi toClass(Map<String, dynamic> map) {
    ProductResponseApi newInstance = ProductResponseApi();
    if (map.containsKey('total')) newInstance.total = map['total'];
    if (map.containsKey('pages')) newInstance.pages = map['pages'];


    if (map.containsKey('maxOrderAmount')) newInstance.maxOrderAmount = map['maxOrderAmount'];

    if (map.containsKey('_id')) newInstance.Id = map['_id'];
    if (map.containsKey('stock')) newInstance.stock = map['stock'];
    if (map.containsKey('imageUrl')) newInstance.image = map['imageUrl'];

    if (map.containsKey('storeName')) {
      if (map["storeName"] is Map){
        newInstance.storeNames = map['storeName'];
      }
      else if (map["storeName"] is String){
        newInstance.storeName = map['storeName'];
      }
    }

    if (map.containsKey('cityName')) {
      if (map["cityName"] is Map){
        newInstance.cityNames = map['cityName'];
      }
      else if (map["cityName"] is String){
        newInstance.cityName = map['cityName'];
      }
    }

    if (map.containsKey('localizedNames')) newInstance.productNames = map['localizedNames'];
    if (map.containsKey('productName')) newInstance.productName = map['productName'];
    if (map.containsKey('sellingPrice')) newInstance.amount = map['sellingPrice'];
    if (map.containsKey('productDescription')) newInstance.description = map['productDescription'];
    if (map.containsKey('storeId')) newInstance.storeId = map['storeId'];
    if (map.containsKey('qtyIncrements')) newInstance.qntIncrements = (map['qtyIncrements'] as List<dynamic>).cast<num>();
    if (map.containsKey('unitOfMeasure')) newInstance.unitOfMeasure = UnitOfMeasure().toClass(map['unitOfMeasure']);
    if (map.containsKey('brand')) newInstance.brand = Brand().toClass(map['brand']);
    if (map.containsKey('category')) newInstance.category = Category().toClass(map['category']);

    if (map.containsKey('tax')) {
      newInstance.fees = List();
      List<dynamic> jsonArray = map['tax'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((fee) {
          newInstance.fees.add(Fee().toClass(fee));
        });
      }
    }
    return newInstance;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.stock != null) map['stock'] = this.stock;
    if (this.image != null) map['imageUrl'] = this.image;
    if (this.productNames != null) map['localizedNames'] = this.productNames;
    if (this.productName != null) map['productName'] = this.productName;
    if (this.amount != null) map['sellingPrice'] = this.amount;
    if (!this.description.isInvalid()) map['productDescription'] = this.description;
    if (this.storeId != null) map['storeId'] = this.storeId;
    if (this.qntIncrements != null) map['qtyIncrements'] = this.qntIncrements;
    if (this.unitOfMeasure != null) map['unitOfMeasure'] = this.unitOfMeasure.toMap();
    if (this.brand != null) map['brand'] = this.brand.toMap();
    if (this.category != null) map['category'] = this.category.toMap();

    if (!this.fees.isInvalid()) {
      List<dynamic> list = List();
      this.fees.forEach((fee) {
        list.add(fee.toMap());
      });
      map['fees'] = list;
    }

    return map;
  }
}

////////////////////////////////////////////////////////////////////////////////////

class UnitOfMeasure extends ApiBaseModel<UnitOfMeasure>{
  String name;
  String symbol;

  UnitOfMeasure({this.name, this.symbol});

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('symbol')) this.symbol = map['symbol'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.symbol.isInvalid()) map['symbol'] = this.symbol;
    return map;
  }
}

///////////////////////////////////////////////////////////////////////////////////

class Brand extends ApiBaseModel<Brand>{
  String id;
  String name;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('_id')) this.id = map['_id'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.id.isInvalid()) map['_id'] = this.id;
    return map;
  }
}

///////////////////////////////////////////////////////////////////////////////////

class Category extends ApiBaseModel<Category>{
  String id;
  String name;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('_id')) this.id = map['_id'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.id.isInvalid()) map['_id'] = this.id;
    return map;
  }
}
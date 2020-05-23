import 'dart:convert';

import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/localization_helper.dart';

import 'base_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
class ProductEntity extends BaseEntity<ProductEntity> {
  int ID;
  String Id;
  String productName = "";
  Map<String, dynamic> productNames;
  String storeId;
  String image;
  num productAmount;
  String description;
  String storeName;
  String cityName;
  num stock;
  List<num> qntIncrements;
  UnitOfMeasure unitOfMeasure;
  Brand brand;
  Category category;
  List<FeesEntity> fees;

  // don't make this zero or null, this will be the default value
  num inCartCount = 1;
  bool isAddedToCart = false;
  // removing this will case a null exception in UI
  int inventoryCount = 100;

  num storeMaxOrderLimit;

  @override
  String alterTable() {
    return null;
  }
  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID TEXT PRIMARY KEY' +
        ', productName TEXT ' +
        ', localizedNames TEXT ' +
        ', _id TEXT ' +
        ', image TEXT' +
        ', description TEXT' +
        ', storeId TEXT' +
        ', qntIncrements TEXT' +
        ', unitOfMeasure TEXT' +
        ', productAmount REAL' +
        ', fees TEXT' +
        ', status TEXT' +
        ', stock INTEGER' +
        ')';
  }
  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }
  @override
  ProductEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.Id = map['ID'];
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('stock')) this.stock = map['stock'];
    if (map.containsKey('imageUrl')) this.image = map['imageUrl'];
    if (map.containsKey('localizedNames')) this.productNames = jsonDecode(map['localizedNames']);
    if (map.containsKey('productName')) this.productName = map['productName'];
    if (map.containsKey('isAddedToCart')) this.isAddedToCart = map['isAddedToCart'];

    if (map.containsKey('storeMaxOrderLimit')) this.storeMaxOrderLimit = map['storeMaxOrderLimit'];

    if (map.containsKey('storeName')) this.storeName = map['storeName'];
    if (map.containsKey('cityName')) this.cityName = map['cityName'];

    if (map.containsKey('inCartCount')) {
      if (map['inCartCount'] is int) this.inCartCount = (map['inCartCount'] as int).toDouble();
      else if (map['inCartCount'] is double) this.inCartCount = map['inCartCount'];
    }
    if (map.containsKey('sellingPrice')) this.productAmount = map['sellingPrice'];
    if (map.containsKey('productDescription')) this.description = map['productDescription'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('qntIncrements')) this.qntIncrements = List<num>.from(jsonDecode(map['qntIncrements']) as List<dynamic>);
    if (map.containsKey('unitOfMeasure')) this.unitOfMeasure = UnitOfMeasure().toClass(jsonDecode(map['unitOfMeasure']));
    if (map.containsKey('brand')) this.brand = Brand().toClass(jsonDecode(map['brand']));
    if (map.containsKey('category')) this.category = Category().toClass(jsonDecode(map['category']));

    if (map.containsKey('fees')) {
      List<dynamic> jsonArr = jsonDecode(map['fees']);
      fees = List();
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((item) {
          fees.add(FeesEntity().toClass(item));
        });
      }
    }

    return this;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.ID != null) map['ID'] = this.ID;
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.stock != null) map['stock'] = this.stock;
    if (this.image != null) map['imageUrl'] = this.image;
    if (this.productNames != null) map['localizedNames'] = jsonEncode(this.productNames);
    if (this.productName != null) map['productName'] = this.productName;
    if (this.productAmount != null) map['sellingPrice'] = this.productAmount;
    if (this.inCartCount != null) map['inCartCount'] = this.inCartCount;
    if (this.isAddedToCart != null) map['isAddedToCart'] = this.isAddedToCart;
    if (!this.description.isInvalid()) map['productDescription'] = this.description;
    if (this.storeId != null) map['storeId'] = this.storeId;
    if (this.qntIncrements != null) map['qntIncrements'] = jsonEncode(this.qntIncrements.toList());
    if (this.unitOfMeasure != null) map['unitOfMeasure'] = jsonEncode(this.unitOfMeasure.toMap());
    if (this.storeMaxOrderLimit != null) map['storeMaxOrderLimit'] = this.storeMaxOrderLimit;
    if (this.brand != null) map['brand'] = jsonEncode(this.brand.toMap());
    if (this.category != null) map['category'] = jsonEncode(this.category.toMap());
    if (!this.fees.isInvalid())
      map['fees'] = json.encode(this.fees.map((i) => i.toMap()).toList());


    if (this.storeName != null) map['storeName'] = this.storeName;
    if (this.cityName != null) map['cityName'] = this.cityName;

    return map;
  }
  Future<ProductEntity> toProductEntity(ProductResponseApi responseApi) async {
    ProductEntity newProduct = ProductEntity();
    newProduct.Id = responseApi.Id;
    newProduct.stock = responseApi.stock;
    newProduct.image = responseApi.image;
    newProduct.productName = responseApi.productName;
    newProduct.productNames = responseApi.productNames;
    newProduct.productAmount = responseApi.amount;
    newProduct.description = responseApi.description;
    newProduct.storeId = responseApi.storeId;
    newProduct.qntIncrements = responseApi.qntIncrements;
    newProduct.unitOfMeasure = responseApi.unitOfMeasure;
    newProduct.brand = responseApi.brand;
    newProduct.category = responseApi.category;
    newProduct.storeMaxOrderLimit = responseApi.maxOrderAmount;
    if (responseApi.storeName == null){
      newProduct.storeName = await LanguageHelper(names: responseApi.storeNames).getName();
    }
    if (responseApi.cityName == null){
      newProduct.cityName = await LanguageHelper(names: responseApi.cityNames).getName();
    }

    newProduct.fees = List();
    if (responseApi.fees != null){
      responseApi.fees.forEach((resFee){
        newProduct.fees.add(FeesEntity().convertToFeesEntity(resFee));
      });
    }

    return newProduct;
  }
}
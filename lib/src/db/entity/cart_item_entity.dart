import 'dart:convert';
import 'dart:core';
import 'package:food_deliver/src/db/entity/package_entity.dart';
import 'package:food_deliver/src/db/entity/payment_methods_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

import 'base_entity.dart';

class CartItemEntity extends BaseEntity<CartItemEntity> {
  int ID;
  ProductEntity product;
  String userId;
  num total;
  num quantity;
  num storeMaxOrderLimit;
  String productId;
  PaymentMethodEntity paymentMethods;

  //
  bool isChanged = false;

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', product TEXT ' +
        ', userId TEXT' +
        ', productId TEXT' +
        ', total REAL' +
        ', storeMaxOrderLimit REAL' +
        ', quantity INTEGER' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  CartItemEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('userId')) this.userId = map['userId'];
    if (map.containsKey('productId')) this.productId = map['productId'];
    if (map.containsKey('total')) this.total = map['total'];
    if (map.containsKey('storeMaxOrderLimit') ) {
      if (map['storeMaxOrderLimit'] is double) {
        this.storeMaxOrderLimit = map['storeMaxOrderLimit'];
      } else {
        this.storeMaxOrderLimit = (map['storeMaxOrderLimit'] as int) != null
            ? (map['storeMaxOrderLimit'] as int).toDouble() : null;
      }
    }
    if (map.containsKey('quantity')) {
      if (map['quantity'] is int) this.quantity = (map['quantity'] as int).toDouble();
      else if (map['quantity'] is double) this.quantity = map['quantity'];
    }
    if (map.containsKey('product'))
      this.product = ProductEntity().toClass(jsonDecode(map['product']));

    if (map.containsKey('paymentMethods'))
      this.paymentMethods =
          PaymentMethodEntity().toClass(jsonDecode(map['paymentMethods']));

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.userId.isInvalid()) map['userId'] = this.userId;
    if (!this.productId.isInvalid()) map['productId'] = this.productId;
    if (total != null) map['total'] = this.total;
    if (storeMaxOrderLimit != null)
      map['storeMaxOrderLimit'] = this.storeMaxOrderLimit;
    if (quantity != null) map['quantity'] = this.quantity;
    if (product != null) map['product'] = json.encode(this.product.toMap());
    if (paymentMethods != null)
      map['paymentMethods'] = json.encode(this.paymentMethods.toMap());

    return map;
  }

  @override
  List<CartItemEntity> toClassArray(List<Map<String, dynamic>> array) {
    return array.map((map) => CartItemEntity().toClass(map)).toList();
  }

  Future<CartItemEntity> addProduct(ProductEntity product) async {
    CartItemEntity cartItemEntity = new CartItemEntity();
    cartItemEntity.product = product;
    cartItemEntity.productId = product.Id;
    cartItemEntity.quantity = 1;
    cartItemEntity.total = product.productAmount;
    cartItemEntity.userId = (await UserAuth().getCurrentUser()).authId;

    return cartItemEntity;
  }
}

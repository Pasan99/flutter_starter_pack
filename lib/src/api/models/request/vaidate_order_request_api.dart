import 'package:flutter/material.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class ValidateOrderRequestApi extends ApiBaseModel<ValidateOrderRequestApi>{
  String storeId;
  List<PackageValidation> packages;
  List<FeeValidation> fees;

  ValidateOrderRequestApi({ @required this.fees, @required this.packages, @required this.storeId,});

  @override
  ValidateOrderRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('storeId')) this.storeId = map['storeId'];

    if (map.containsKey('packages')) {
      packages = List();
      List<dynamic> jsonArr = map['packages'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          packages.add(PackageValidation().toClass(package));
        });
      }
    }

    if (map.containsKey('fees')) {
      fees = List();
      List<dynamic> jsonArr = map['fees'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((fee) {
          fees.add(FeeValidation().toClass(fee));
        });
      }
    }


    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (!this.fees.isInvalid()) {
      var newFees = fees.map((fee)=> fee.toMap()).toList();
      map['fees'] = newFees;
    }
    if (!this.packages.isInvalid()) {
      var newPackages = packages.map((fee)=> fee.toMap()).toList();
      map['packages'] = newPackages;
    }
    return map;
  }

}

class PackageValidation extends ApiBaseModel<PackageValidation> {
  String packageId;
  double qty;
  double perPackageAmount;

  @override
  PackageValidation toClass(Map<String, dynamic> map) {
    if (map.containsKey('packageId')) this.packageId = map['packageId'];
    if (map.containsKey('qty')) this.qty = map['qty'];
    if (map.containsKey('perPackageAmount')) this.perPackageAmount = (map['perPackageAmount'] as int).toDouble();

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.packageId.isInvalid()) map['packageId'] = this.packageId;
    if (qty!= null) map['qty'] = this.qty;
    if (perPackageAmount != null) map['perPackageAmount'] = this.perPackageAmount;

    return map;
  }

  PackageValidation toOrderItem(CartItemEntity cartItemEntity){
    PackageValidation orderItem = new PackageValidation();
    orderItem.packageId = cartItemEntity.product.Id;
    orderItem.qty = cartItemEntity.quantity;
    orderItem.perPackageAmount = cartItemEntity.product.productAmount;
    return orderItem;
  }

}

class FeeValidation extends ApiBaseModel<FeeValidation> {
  String feeId;
  Map<String, dynamic> name;
  String feeType;
  double amount;

  @override
  FeeValidation toClass(Map<String, dynamic> map) {
    if (map.containsKey('feeId')) this.feeId = map['feeId'];
    if (map.containsKey('feeType')) this.feeType = map['feeType'];
    if (map.containsKey('amount')) this.amount = (map['amount'] as int).toDouble();
    if (map.containsKey('name')) this.name = map['name'];

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.feeId.isInvalid()) map['feeId'] = this.feeId;
    if (!this.feeType.isInvalid()) map['feeType'] = this.feeType;
    if (amount != null) map['amount'] = this.amount;
    if (name != null) map['name'] = this.name;
    return map;
  }

  FeeValidation toFeeValidation(FeesEntity feesEntity){
    FeeValidation feesRequestApi = new FeeValidation();
    feesRequestApi.feeId = feesEntity.feeID;
    feesRequestApi.amount = feesEntity.amount.toDouble();
    feesRequestApi.name = feesEntity.names;
    feesRequestApi.feeType = feesEntity.feeType;
    return feesRequestApi;
  }

}

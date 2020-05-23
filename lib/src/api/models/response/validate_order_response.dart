
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class ValidateOrderResponseApi extends ApiBaseModel<ValidateOrderResponseApi>{
  String storeId;
  List<PackageValidationResponse> packages;
  List<FeeValidationResponse> fees;
  List<dynamic> payment;
  String deliveryDate;


  @override
  ValidateOrderResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('deliveryDate')) this.deliveryDate = map['deliveryDate'];
    if (map.containsKey('payment')) this.payment = map['payment'];

    if (map.containsKey('packages')) {
      packages = List();
      List<dynamic> jsonArr = map['packages'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          packages.add(PackageValidationResponse().toClass(package));
        });
      }
    }

    if (map.containsKey('fees')) {
      fees = List();
      List<dynamic> jsonArr = map['fees'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((fee) {
          fees.add(FeeValidationResponse().toClass(fee));
        });
      }
    }


    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (!this.fees.isInvalid()) map['fees'] = this.fees;
    if (!this.packages.isInvalid()) map['packages'] = this.packages;
    if (!this.deliveryDate.isInvalid()) map['deliveryDate'] = this.deliveryDate;
    if (!this.payment.isInvalid()) map['payment'] = this.payment;
    return map;
  }

}

class PackageValidationResponse extends ApiBaseModel<PackageValidationResponse> {
  String packageId;
  int inventoryCount;
  double perPackageAmount;
  String status;

  @override
  PackageValidationResponse toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.packageId = map['_id'];
    if (map.containsKey('inventoryCount')) this.inventoryCount = map['inventoryCount'];
    if (map.containsKey('status')) this.status = map['status'];
    if (map.containsKey('perPackageAmount')) this.perPackageAmount = (map['perPackageAmount'] as int).toDouble();

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.packageId.isInvalid()) map['_id'] = this.packageId;
    if (inventoryCount!= null) map['inventoryCount'] = this.inventoryCount;
    if (status!= null) map['status'] = this.status;
    if (perPackageAmount != null) map['perPackageAmount'] = this.perPackageAmount;

    return map;
  }

}

class FeeValidationResponse extends ApiBaseModel<FeeValidationResponse> {
  String feeId;
  Map<String, dynamic> name;
  String feeType;
  double amount;

  @override
  FeeValidationResponse toClass(Map<String, dynamic> map) {
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

}

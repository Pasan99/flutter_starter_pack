import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class ConfigurationResponseApi extends ApiBaseModel<ConfigurationResponseApi> {
  Configuration configuration;
  List<Fee> fees;

  @override
  toClass(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('configuration'))
      this.configuration = Configuration().toClass(map['configuration']);

    if (map.containsKey('fees')) {
      this.fees = List();
      List<dynamic> jsonArray = map['fees'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((fee) {
          fees.add(Fee().toClass(fee));
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.configuration != null)
      map['configuration'] = this.configuration.toMap();

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

class Configuration extends ApiBaseModel<Configuration> {
  String _id;
  int maxCashOrderAmount;
  String updatedAt;
  String createdAt;
  int __v;

  @override
  toClass(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('maxCashOrderAmount'))
      this.maxCashOrderAmount = map['maxCashOrderAmount'];
    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];
    if (map.containsKey('__v')) this.__v = map['__v'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (this.maxCashOrderAmount != null)
      map['maxCashOrderAmount'] = this.maxCashOrderAmount;
    if (!this.updatedAt.isInvalid()) map['updatedAt'] = this.updatedAt;
    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;
    if (this.__v != null) map['__v'] = this.__v;

    return map;
  }

  String get id => _id;

  int get v => __v;
}

class Fee extends ApiBaseModel<Fee> {
  Map<String, dynamic> name;
  String convertedName;
  String _id;
  String feeType;
  num feeRate;
  String merchantId;

  Fee({this.feeRate, this.convertedName, this.feeType});

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('name')) {
      if (map['name'] is Map) {
        this.name = map['name'];
      }
      else {
        this.convertedName = map['name'];
      }
    }

    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('taxType')) this.feeType = map['taxType'];
    if (map.containsKey('taxRate')) this.feeRate = map['taxRate'];
    if (map.containsKey('merchantId')) this.merchantId = map['merchantId'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.name != null) map['name'] = name;
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (!this.feeType.isInvalid()) map['taxType'] = this.feeType;
    if (this.feeRate != null) map['taxRate'] = this.feeRate;
    if (this.merchantId != null) map['merchantId'] = this.merchantId;
    return map;
  }
}

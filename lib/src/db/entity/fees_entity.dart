import 'dart:convert';

import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class FeesEntity extends BaseEntity<FeesEntity> {
  int ID;
  Map<String, dynamic>names;
  String name;
  String feeType;
  num amount;
  String feeID;
  double finalAmount;
  String feeRate;
  String merchantId;


  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', name TEXT ' +
        ', convertedName TEXT ' +
        ', feeType TEXT ' +
        ', amount REAL ' +
        ', feeID TEXT ' +
        ', feeRate TEXT ' +
        ', merchantId TEXT ' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  FeesEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['_id'];
    if (map.containsKey('name')) this.names = jsonDecode(map['name']);
    if (map.containsKey('convertedName')) this.name = jsonDecode(map['convertedName']);
    if (map.containsKey('feeType')) this.feeType = map['feeType'];
    if (map.containsKey('amount')) this.amount = map['amount'];
    if (map.containsKey('feeID')) this.feeID = map['feeID'];
    if (map.containsKey('feeRate')) this.feeRate = map['feeRate'];
    if (map.containsKey('merchantId')) this.merchantId = map['merchantId'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.ID != null) map['ID'] = this.ID;
    if (names != null) map['name'] = jsonEncode(this.names);
    if (name != null) map['convertedName'] = jsonEncode(this.name);
    if (!feeType.isInvalid()) map['feeType'] = this.feeType;
    if (amount != null) map['amount'] = this.amount;
    if (!feeID.isInvalid()) map['feeID'] = this.feeID;
    if (!feeRate.isInvalid()) map['feeRate'] = this.feeRate;
    if (!merchantId.isInvalid()) map['merchantId'] = this.merchantId;
    return map;
  }

  FeesEntity convertToFeesEntity(Fee fee) {
    if (fee == null) return null;

    FeesEntity feeEntity = FeesEntity();
    if (fee.name != null) feeEntity.names = fee.name;
    if (fee.convertedName != null) feeEntity.name = fee.convertedName;
    if (!fee.feeType.isInvalid()) feeEntity.feeType = fee.feeType;
    if (fee.feeRate != null) feeEntity.amount = fee.feeRate;
    if (fee.merchantId != null) feeEntity.merchantId = fee.merchantId;
    if (fee.feeType != null) feeEntity.feeRate = (fee.feeType == "%" ? (fee.feeRate.toString() + fee.feeType) : ("LKR ${fee.feeRate}"));
    return feeEntity;
  }

  @override
  List<FeesEntity> toClassArray(List<Map<String, dynamic>> array) {
    return array.map((map) => FeesEntity().toClass(map)).toList();
  }


}

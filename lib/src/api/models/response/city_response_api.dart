import 'dart:convert';

import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class CityResponseApi extends ApiBaseModel<CityResponseApi> {
  String _id;
  CityName name;
  String districtId;
//  String updatedAt;
//  String createdAt;
  bool isDeleted;

  @override
  CityResponseApi toClass(Map<String, dynamic> map) {
    if (map['_id'] == null) return null;
    if (map.containsKey('_id') && map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('name')) {
      if (map['name'] is String) return null;
      this.name = CityName().toClass(map['name']);
    }
    if (map.containsKey('districtId')) this.districtId = map['districtId'];
//    if (map.containsKey('updatedAt')) this.updatedAt = map['updatedAt'];
//    if (map.containsKey('createdAt')) this.createdAt = map['createdAt'];
    if (map.containsKey('isDeleted')) this.isDeleted = map['isDeleted'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (this.name != null) map['name'] = this.name.toMap();
    if (!this.districtId.isInvalid()) map['districtId'] = this.districtId;
//    if (this.updatedAt != null) map['updatedAt'] = this.updatedAt;
//    if (!this.createdAt.isInvalid()) map['createdAt'] = this.createdAt;
    if (isDeleted != null) map['isDeleted'] = this.isDeleted;
    return map;
  }

  String get id => _id; //getter
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

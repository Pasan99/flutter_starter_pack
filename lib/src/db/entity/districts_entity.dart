import 'dart:convert';

import 'package:food_deliver/src/api/models/response/district_with_cities_response_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class DistrictEntity extends BaseEntity<DistrictEntity> {
  int ID;
  Map<String, dynamic> districtName; //name map
  String districtID; //DistrictWithCityResponseApi().district._id

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', districtName TEXT' +
        ', districtID TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  DistrictEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('districtName'))
      this.districtName = jsonDecode(map['districtName']);
    if (map.containsKey('districtID')) this.districtID = map['districtID'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (districtName != null)
      map['districtName'] = jsonEncode(this.districtName);
    if (!districtID.isInvalid()) map['districtID'] = this.districtID;
    return map;
  }

  @override
  List<DistrictEntity> toClassArray(List<Map<String, dynamic>> array) {
    List<DistrictEntity> list = List();
    if(array.isInvalid()) return list;

    array.forEach((district) {
      if(district != null && district.isNotEmpty)
        list.add(DistrictEntity().toClass(district));
    });

    return list;
  }

  ///create the District entity object with the api response
  ///
  ///[newObject] is the [District] object in [district_with_cities_response_api]
  DistrictEntity convertToDistrictEntity(District newObject) {
    if (newObject == null) return null;

    DistrictEntity districtEntity = DistrictEntity();
    if (newObject.districtName != null) {
      districtEntity.districtName = newObject.districtName.toMap();
    }
    if (!newObject.id.isInvalid()) districtEntity.districtID = newObject.id;
    print('db fields: ' +
        districtEntity.districtName.toString() +
        districtEntity.districtID);
    return districtEntity;
  }
}

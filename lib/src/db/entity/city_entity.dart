import 'dart:convert';

import 'package:food_deliver/src/api/models/response/city_response_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class CityEntity extends BaseEntity<CityEntity> {
  int ID;
  Map<String, dynamic> name; //name map
  int isDeleted;
  int districtId;

  /// foreign key of DistrictEntity
  String cityID; //_id of CityResponseApi

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', name TEXT' +
        ', isDeleted INTEGER' +
        ', districtId INTEGER' +
        ', cityID TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
    ;
  }

  @override
  CityEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('name')) this.name = jsonDecode(map['name']);
    if (map.containsKey('isDeleted')) this.isDeleted = map['isDeleted'];
    if (map.containsKey('districtId')) this.districtId = map['districtId'];
    if (map.containsKey('cityID')) this.cityID = map['cityID'];
    return this;
  }

  @override
  List<CityEntity> toClassArray(List<Map<String, dynamic>> array) {
    List<CityEntity> list = List();
    if(array.isInvalid()) return list;

    array.forEach((city) {
      if(city != null && city.isNotEmpty)
        list.add(CityEntity().toClass(city));
    });

    return list;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (name != null) map['name'] = jsonEncode(this.name);
    if (this.isDeleted != null) map['isDeleted'] = this.isDeleted;
    if (this.districtId != null) map['districtId'] = this.districtId;
    if (!this.cityID.isInvalid()) map['cityID'] = this.cityID;
    return map;
  }

  ///create the City entity object with the api response
  ///
  ///[newObject] is the [CityResponseApi] object in [district_with_cities_response_api]
  ///[districtId] is the foreign key of DistrictEntity
  CityEntity convertToCityEntity(CityResponseApi newObject, int districtId) {
    if (newObject == null) return null;

    CityEntity cityEntity = CityEntity();
    if (newObject.name != null) {
      cityEntity.name = newObject.name.toMap();
    }
    if (newObject.isDeleted != null)
      cityEntity.isDeleted = newObject.isDeleted ? 1 : 0;
    if (districtId != null) cityEntity.districtId = districtId;
    if (!newObject.id.isInvalid()) cityEntity.cityID = newObject.id;

    return cityEntity;
  }
}

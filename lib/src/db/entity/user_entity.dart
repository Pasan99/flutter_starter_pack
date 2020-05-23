import 'dart:convert';

import 'package:food_deliver/src/api/models/response/user_response_api.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';

import 'base_entity.dart';

class UserEntity extends BaseEntity<UserEntity> {
  int ID;
  String name;
  String mobileNumber;
  String nic;
  String cityId;
  String mainRoad;
  String street;
  String houseNo;
  String authId;
  List<String> landMarks;
  GpsCoordinates gpsCoordinates;
  String language;
  List<String> ordersList;
  String selectedContactId;
  String accessToken;

  //ignore these fields while creating the DB
  String districtName;
  String cityName;

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY ' +
        ', name TEXT ' +
        ', mobileNumber TEXT' +
        ', nic TEXT' +
        ', cityId TEXT' +
        ', mainRoad TEXT' +
        ', authId TEXT' +
        ', street TEXT' +
        ', houseNo TEXT' +
        ', language TEXT' +
        ', landMarks TEXT' +
        ', gpsCoordinates TEXT' +
        ', ordersList TEXT' +
        ', selectedContactId TEXT' +
        ', accessToken TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  UserEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('authId')) this.authId = map['authId'];
    if (map.containsKey('accessToken')) this.accessToken = map['accessToken'];
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('mobileNumber'))
      this.mobileNumber = map['mobileNumber'];
    if (map.containsKey('nic')) this.nic = map['nic'];
    if (map.containsKey('cityId')) this.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('language')) this.language = map['language'];
    if (map.containsKey('selectedContactId'))
      this.selectedContactId = map['selectedContactId'];

    if (map.containsKey('gpsCoordinates') && map["gpsCoordinates"] != null)
      this.gpsCoordinates =
          GpsCoordinates().toClass(jsonDecode(map['gpsCoordinates']));

    if (map.containsKey('landMarks') && map['landMarks'] != null) {
      landMarks = List<String>();
      List<dynamic> jsonArr = jsonDecode(map['landMarks']);
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          landMarks.add(landmark);
        });
      }
    }

    if (map.containsKey('ordersList') && map['ordersList'] != null) {
      ordersList = List<String>();
      List<dynamic> jsonArr = jsonDecode(map['ordersList']);
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((orderId) {
          ordersList.add(orderId);
        });
      }
    }

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.ID != null) map['ID'] = this.ID;
    if (!this.authId.isInvalid()) map['authId'] = this.authId;
    if (!this.accessToken.isInvalid()) map['accessToken'] = this.accessToken;
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.mobileNumber.isInvalid()) map['mobileNumber'] = this.mobileNumber;
    if (!this.nic.isInvalid()) map['nic'] = this.nic;
    if (!this.cityId.isInvalid()) map['cityId'] = this.cityId;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;
    if (!this.language.isInvalid()) map['language'] = this.language;
    if (!this.selectedContactId.isInvalid())
      map['selectedContactId'] = this.selectedContactId;
    if (this.gpsCoordinates != null)
      map['gpsCoordinates'] = json.encode(this.gpsCoordinates.toMap());

    if (!this.landMarks.isInvalid())
      map['landMarks'] = json.encode(this.landMarks.toList());
    if (!this.ordersList.isInvalid())
      map['ordersList'] = json.encode(this.ordersList.toList());

    return map;
  }

  UserEntity convertToUserEntity(UserResponseApi newObject) {
    UserEntity userEntity = UserEntity();
    if (!newObject.name.isInvalid()) userEntity.name = newObject.name;
    if (!newObject.mobileNumber.isInvalid())
      userEntity.mobileNumber = newObject.mobileNumber;
    if (!newObject.nic.isInvalid()) userEntity.nic = newObject.nic;
    if (!newObject.cityId.isInvalid()) userEntity.cityId = newObject.cityId;
    if (!newObject.mainRoad.isInvalid())
      userEntity.mainRoad = newObject.mainRoad;
    if (!newObject.street.isInvalid()) userEntity.street = newObject.street;
    if (!newObject.houseNo.isInvalid()) userEntity.houseNo = newObject.houseNo;
    if (!newObject.Id.isInvalid()) userEntity.authId = newObject.Id;
    if (!newObject.landMarks.isInvalid())
      userEntity.landMarks = newObject.landMarks;
    if (newObject.gpsCoordinates != null)
      userEntity.gpsCoordinates = newObject.gpsCoordinates;
    if (!newObject.ordersList.isInvalid())
      userEntity.ordersList = newObject.ordersList;

    return userEntity;
  }

  ContactEntity toContactEntity(UserEntity userEntity){
    ContactEntity contactEntity = new ContactEntity();
    contactEntity.name = userEntity.name;
    contactEntity.contactNumber = userEntity.mobileNumber;
    contactEntity.nicNumber = userEntity.nic;
    contactEntity.mainRoad = userEntity.mainRoad;
    contactEntity.street = userEntity.street;
    contactEntity.houseNo = userEntity.houseNo;
    contactEntity.cityId = userEntity.cityId;

    return contactEntity;
  }
}

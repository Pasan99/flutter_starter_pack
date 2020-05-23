import 'dart:convert';

import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';

class ContactEntity extends BaseEntity<ContactEntity> {
  int ID;
  int isDeleted;
  String _id;
  List<String> landmarks; //jsonEncoded(List<String>)
  String name;
  String nicNumber;
  String mainRoad;
  String street;
  String houseNo;
  String contactNumber;
  String cityId;
  String userId; //back end ID
  GpsCoordinates gpsCoordinates;

  //ignored fields. only for presentation purposes.
  String districtName;
  String cityName;

  String get contactID => _id;

  set contactID(String id) => this._id = id;

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', isDeleted INTEGER' +
        ', landmarks TEXT' +
        ', _id TEXT' +
        ', name TEXT' +
        ', nicNumber TEXT' +
        ', cityId TEXT' +
        ', mainRoad TEXT' +
        ', street TEXT' +
        ', houseNo TEXT' +
        ', contactNumber TEXT' +
        ', userId TEXT' +
        ', gpsCoordinates TEXT' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  ContactEntity toClass(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('isDeleted')) this.isDeleted = map['isDeleted'];
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('nicNumber')) this.nicNumber = map['nicNumber'];
    if (map.containsKey('cityId')) this.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('contactNumber'))
      this.contactNumber = map['contactNumber'];
    if (map.containsKey('userId')) this.userId = map['userId'];

    if (map.containsKey('gpsCoordinates') && map["gpsCoordinates"] != null)
      this.gpsCoordinates =
          GpsCoordinates().toClass(jsonDecode(map['gpsCoordinates']));

    if (map.containsKey('landmarks') && map['landmarks'] != null) {
      landmarks = List<String>();
      List<dynamic> jsonArr = jsonDecode(map['landmarks']);
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          landmarks.add(landmark);
        });
      }
    }

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.isDeleted != null) map['isDeleted'] = this.isDeleted;
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.nicNumber.isInvalid()) map['nicNumber'] = this.nicNumber;
    if (!this.cityId.isInvalid()) map['cityId'] = this.cityId;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;
    if (!this.contactNumber.isInvalid())
      map['contactNumber'] = this.contactNumber;
    if (!this.userId.isInvalid()) map['userId'] = this.userId;

    if (this.gpsCoordinates != null)
      map['gpsCoordinates'] = json.encode(this.gpsCoordinates.toMap());

    if (!this.landmarks.isInvalid())
      map['landmarks'] = json.encode(this.landmarks.toList());
    return map;
  }

  @override
  List<ContactEntity> toClassArray(List<Map<String, dynamic>> array) {
    List<ContactEntity> list = List();
    if (array.isInvalid()) return list;

    array.forEach((map) {
      if (map != null && map.isNotEmpty) {
        list.add(ContactEntity().toClass(map));
      }
    });

    return list;
  }

  ///create and get contact object from contact API response body
  ContactEntity convertToContactEntity(ContactsRequestAPI newObject) {
    ContactEntity userEntity = ContactEntity();
    if (!newObject.contactID.isInvalid()) userEntity._id = newObject.contactID;
    if (!newObject.name.isInvalid()) userEntity.name = newObject.name;
    if (!newObject.contactNumber.isInvalid())
      userEntity.contactNumber = newObject.contactNumber;
    if (!newObject.nicNumber.isInvalid())
      userEntity.nicNumber = newObject.nicNumber;
    if (!newObject.cityId.isInvalid()) userEntity.cityId = newObject.cityId;
    if (!newObject.landmarks.isInvalid())
      userEntity.landmarks = newObject.landmarks;
    if (!newObject.mainRoad.isInvalid())
      userEntity.mainRoad = newObject.mainRoad;
    if (!newObject.street.isInvalid()) userEntity.street = newObject.street;
    if (!newObject.houseNo.isInvalid()) userEntity.houseNo = newObject.houseNo;
    if (!newObject.userID.isInvalid()) userEntity.userId = newObject.userID;

    if (newObject.gpsCoordinates != null)
      userEntity.gpsCoordinates = newObject.gpsCoordinates;

    return userEntity;
  }
}

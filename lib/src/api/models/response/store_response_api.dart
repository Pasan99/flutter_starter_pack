import 'dart:convert';

import 'package:food_deliver/src/api/models/response/package_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/package_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';

class StoreResponseApi extends ApiBaseModel<StoreResponseApi> {
  String Id;
  Map<String, dynamic> storeNames;
  String storeImageURL = "";
  String storeName = "";
  String cityId;
  String mainRoad = "";
  GpsCoordinates gpsCoordinates;
  List<String> paymentMethods;
  String status;
  String dsDivisionId;
//  List<String> driverIds;
//  List<BlacklistUser> blackListUsers;
  int maxDailyOrders;
  String statusOpenStatus;
  String street;
  String cityName = "";
  Map<String, dynamic> cityNames;
  num maxOrderAmount;

  int total;
  int pages;

  @override
  StoreResponseApi toClass(Map<String, dynamic> map) {
    StoreResponseApi newObject = StoreResponseApi();

    if (map.containsKey('total')) newObject.total = map['total'];
    if (map.containsKey('pages')) newObject.pages = map['pages'];

    if (map.containsKey('maxOrderAmount')) newObject.maxOrderAmount = map['maxOrderAmount'];
    if (map.containsKey('_id')) newObject.Id = map['_id'];
    if (map.containsKey('storeName')) newObject.storeNames = map['storeName'];
    if (map.containsKey('cityName')){
      if (map['cityName'] is String) {
        newObject.cityName = map['cityName'];
      }
      else{
        newObject.cityNames = map['cityName'];
      }
    }

    if (map.containsKey('storeImageURL'))
      newObject.storeImageURL = map['storeImageURL'];
    if (map.containsKey('cityId')) newObject.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) newObject.mainRoad = map['mainRoad'];
    if (map.containsKey('gpsCoordinates'))
      newObject.gpsCoordinates =
          GpsCoordinates().toClass(map['gpsCoordinates']);
    if (map.containsKey('status')) newObject.status = map['status'];
    if (map.containsKey('dsDivisionId'))
      newObject.dsDivisionId = map['dsDivisionId'];
    if (map.containsKey('maxDailyOrders'))
      newObject.maxDailyOrders = map['maxDailyOrders'];
    if (map.containsKey('statusOpenStatus'))
      newObject.statusOpenStatus = map['statusOpenStatus'];
    if (map.containsKey('street')) newObject.street = map['street'];

    if (map.containsKey('paymentMethods')) {
      newObject.paymentMethods = List<String>();
      List<dynamic> jsonArr = map['paymentMethods'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((method) {
          newObject.paymentMethods.add(method);
        });
      }
    }
//    if (map.containsKey('driverIds')) {
//      newObject.driverIds = List<String>();
//      List<dynamic> jsonArr = map['driverIds'];
//      if (!jsonArr.isInvalid()) {
//        jsonArr.forEach((driverId) {
//          newObject.driverIds.add(driverId);
//        });
//      }
//    }
//    if (map.containsKey('blackListUsers')) {
//      newObject.blackListUsers = List<BlacklistUser>();
//      List<dynamic> jsonArr = map['blackListUsers'];
//      if (!jsonArr.isInvalid()) {
//        jsonArr.forEach((user) {
//          newObject.blackListUsers.add(BlacklistUser().toClass(user));
//        });
//      }
//    }

    return newObject;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.storeNames != null) map['storeName'] = this.storeNames;
    if (!this.storeImageURL.isInvalid())
      map['storeImageURL'] = this.storeImageURL;
    if (this.cityId != null) map['cityId'] = this.cityId;
    if (this.mainRoad != null) map['mainRoad'] = this.mainRoad;
    if (this.gpsCoordinates != null)
      map['gpsCoordinates'] = jsonEncode(this.gpsCoordinates);
    if (this.status != null) map['status'] = this.status;
    if (this.dsDivisionId != null) map['dsDivisionId'] = this.dsDivisionId;
    if (this.maxDailyOrders != null)
      map['maxDailyOrders'] = this.maxDailyOrders;
    if (this.statusOpenStatus != null)
      map['statusOpenStatus'] = this.statusOpenStatus;
    if (this.street != null) map['street'] = this.street;

//    if (this.paymentMethods != null)
//      map['paymentMethods'] = jsonEncode(this.paymentMethods);
//    if (this.driverIds != null) map['driverIds'] = jsonEncode(this.driverIds);
//    if (this.blackListUsers != null)
//      map['blackListUsers'] = jsonEncode(this.blackListUsers.toList());
    return map;
  }
}

import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class UserRequestApi extends ApiBaseModel<UserRequestApi>{
  String Id;
  String name;
  String mobileNumber;
  String nic;
  String cityId;
  String mainRoad;
  String street;
  String houseNo;
  List<String> landMarks;
  GpsCoordinates gpsCoordinates;
  String language;

  UserRequestApi({this.name, this.mobileNumber, this.nic,
    this.cityId, this.mainRoad, this.street, this.houseNo, this.landMarks,
    this.gpsCoordinates, this.language});

  @override
  UserRequestApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('mobileNumber'))
      this.mobileNumber = map['mobileNumber'];
    if (map.containsKey('nic')) this.nic = map['nic'];
    if (map.containsKey('cityId')) this.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('language')) this.language = map['name'];
    if (map.containsKey('gpsCoordinates'))
      this.gpsCoordinates = GpsCoordinates().toClass(map['gpsCoordinates']);

    if (map.containsKey('landMarks')) {
      landMarks = List();
      List<dynamic> jsonArr = map['landMarks'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          landMarks.add(landmark);
        });
      }
    }

//    if (map.containsKey('ordersList')) {
//      ordersList = List();
//      List<dynamic> jsonArr = map['ordersList'];
//      if (!jsonArr.isInvalid()) {
//        jsonArr.forEach((orderIds) {
//          ordersList.add(orderIds);
//        });
//      }
//    }

    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.mobileNumber.isInvalid())
      map['mobileNumber'] = this.mobileNumber;
    if (!this.nic.isInvalid()) map['nic'] = this.nic;
    if (!this.cityId.isInvalid()) map['cityId'] = this.cityId;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;
    if (!this.language.isInvalid()) map['language'] = this.language;
    if (gpsCoordinates != null) map['gpsCoordinates'] = this.gpsCoordinates.toMap();
    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.landMarks.isInvalid()) map['landMarks'] = this.landMarks;
//    if (!this.ordersList.isInvalid()) map['ordersList'] = this.ordersList;
    return map;
  }

}
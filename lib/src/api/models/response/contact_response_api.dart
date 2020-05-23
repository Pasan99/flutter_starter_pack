import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class ContactResoponseApi extends ApiBaseModel<ContactResoponseApi> {
  String name;
  String nicNumber;
  String cityId;
  String mainRoad;
  String street;
  String houseNo;
  List<String> landmarks;
  GpsCoord gpsCoordinates;
  String contactNumber;
  String userID;

  @override
  toClass(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('nicNumber')) this.nicNumber = map['nicNumber'];
    if (map.containsKey('cityId')) this.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];

    if (map.containsKey('landmarks')) {
      this.landmarks = List();
      List<dynamic> jsonArray = map['landmarks'];
      jsonArray.forEach((mark) {
        landmarks.add(mark);
      });
    }

    if (map.containsKey('gpsCoordinates'))
      this.gpsCoordinates = GpsCoord().toClass(map['gpsCoordinates']);

    if (map.containsKey('contactNumber'))
      this.contactNumber = map['contactNumber'];
    if (map.containsKey('userID')) this.userID = map['userID'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.name.isInvalid()) map['userID'] = this.userID;
    if (!this.nicNumber.isInvalid()) map['nicNumber'] = this.nicNumber;
    if (!this.cityId.isInvalid()) map['cityId'] = this.cityId;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;

    if (!this.landmarks.isInvalid()) {
      List<dynamic> list = List();
      this.landmarks.forEach((mark) {
        list.add(mark);
      });
      map['landmarks'] = list;
    }

    if (this.gpsCoordinates != null)
      map['gpsCoordinates'] = this.gpsCoordinates.toMap();

    if (!this.contactNumber.isInvalid())
      map['contactNumber'] = this.contactNumber;
    if (!this.userID.isInvalid()) map['userID'] = this.userID;
    return map;
  }
}

class GpsCoord extends ApiBaseModel<GpsCoord> {
  double lat;
  double lng;

  @override
  toClass(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('lat')) this.lat = map['lat'];
    if (map.containsKey('lng')) this.lng = map['lng'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.lat != null) map['lat'] = this.lat;
    if (this.lng != null) map['lng'] = this.lng;
    return map;
  }
}

import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class GpsCoordinates extends BaseEntity<GpsCoordinates> {
  int Id;
  String type = 'Point';

//  double lat;
//  double lng;
  List<double> coordinates;

  GpsCoordinates({this.coordinates});

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', type TEXT ' +
        ', coordinates TEXT ' +
//        ', lat REAL ' +
//        ', lng REAL' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  @override
  GpsCoordinates toClass(Map<String, dynamic> map) {
    if (map.containsKey('Id')) this.Id = map['Id'];
    if (map.containsKey('type')) this.type = map['type'];
//    if (map.containsKey('lat')) this.lat = map['lat'];
//    if (map.containsKey('lng')) this.lng = map['lng'];

    if (map.containsKey('coordinates')) {
      this.coordinates = List();
      List<dynamic> jsonArr = map['coordinates'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((coordinate) {
          this.coordinates.add(coordinate);
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!withoutUniqueIDs && this.Id != null) map['Id'] = this.Id;
    if (!type.isInvalid()) map['type'] = this.type;
//    if (this.lat != null) map['lat'] = this.lat;
//    if (this.lng != null) map['lng'] = this.lng;

    if (!coordinates.isInvalid()) map['coordinates'] = this.coordinates;
    return map;
  }

  bool isInvalid() {
    if (!coordinates.isInvalid() && coordinates.length == 2) {
      return true;
    }
    return false;
  }
}

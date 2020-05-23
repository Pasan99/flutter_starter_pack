import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/gps_coordinates.dart';

class ContactsRequestAPI extends ApiBaseModel<ContactsRequestAPI> {
  String _id;
  String name;
  String nicNumber;
  String cityId;
  String mainRoad;
  String street;
  String houseNo;
  List<String> landmarks;
  GpsCoordinates gpsCoordinates;
  String contactNumber;
  String userID;

  ContactsRequestAPI(
      {this.name,
      this.nicNumber,
      this.cityId,
      this.mainRoad,
      this.street,
      this.houseNo,
      this.landmarks,
      this.gpsCoordinates,
      this.contactNumber,
      this.userID});

  set contactID(String id) {
    this._id = id;
  }

  String get contactID => _id;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('name')) this.name = map['name'];
    if (map.containsKey('nicNumber')) this.nicNumber = map['nicNumber'];
    if (map.containsKey('cityId')) this.cityId = map['cityId'];
    if (map.containsKey('mainRoad')) this.mainRoad = map['mainRoad'];
    if (map.containsKey('street')) this.street = map['street'];
    if (map.containsKey('houseNo')) this.houseNo = map['houseNo'];
    if (map.containsKey('contactNumber'))
      this.contactNumber = map['contactNumber'];
    if (map.containsKey('userID')) this.userID = map['userID'];
    if (map.containsKey('gpsCoordinates'))
      this.gpsCoordinates = GpsCoordinates().toClass(map['gpsCoordinates']);

    if (map.containsKey('landmarks')) {
      this.landmarks = List();
      List<dynamic> jsonArr = map['landmarks'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((landmark) {
          this.landmarks.add(landmark);
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!withoutUniqueIDs) if (!this._id.isInvalid()) map['_id'] = this._id;

    if (!this.name.isInvalid()) map['name'] = this.name;
    if (!this.nicNumber.isInvalid()) map['nicNumber'] = this.nicNumber;
    if (!this.cityId.isInvalid()) map['cityId'] = this.cityId;
    if (!this.mainRoad.isInvalid()) map['mainRoad'] = this.mainRoad;
    if (!this.street.isInvalid()) map['street'] = this.street;
    if (!this.houseNo.isInvalid()) map['houseNo'] = this.houseNo;
    if (!this.contactNumber.isInvalid())
      map['contactNumber'] = this.contactNumber;
    if (!this.userID.isInvalid()) map['userID'] = this.userID;
    if (this.gpsCoordinates != null)
      map['gpsCoordinates'] = this.gpsCoordinates.toMap();
    if (!this.landmarks.isInvalid()) map['landmarks'] = this.landmarks;
    return map;
  }
}

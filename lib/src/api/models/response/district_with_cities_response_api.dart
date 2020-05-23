import 'package:food_deliver/src/api/models/response/city_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class DistrictWithCitiesResponseApi
    extends ApiBaseModel<DistrictWithCitiesResponseApi> {
  List<District> districtList;

  @override
  DistrictWithCitiesResponseApi listToClass(List array) {
    districtList = List();

    if (array.isInvalid()) return null;

    for (int i = 0; i < array.length; i++) {
      District district = District();
      districtList.add(district.toClass(array.elementAt(i)));
    }

    return this;
  }

  @override
  DistrictWithCitiesResponseApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    return null;
  }
}

class District extends ApiBaseModel<District> {
  String _id;
  DistrictName districtName;
  List<CityResponseApi> cities;

  @override
  District toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this._id = map['_id'];
    if (map.containsKey('districtName')) {
      if (!(map['districtName'] is Map)) return null;
      this.districtName = DistrictName().toClass(map['districtName']);
    }

    if (map.containsKey('cities')) {
      this.cities = List();
      List<dynamic> jsonArray = map['cities'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((city) {
          if (!map.containsKey('_id')) return null;
          cities.add(CityResponseApi().toClass(city));
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this._id.isInvalid()) map['_id'] = this._id;
    if (this.districtName != null)
      map['districtName'] = this.districtName.toMap();

    if (!this.cities.isInvalid()) {
      List<dynamic> list = List();
      this.cities.forEach((CityResponseApi) {
        list.add(CityResponseApi.toMap());
      });
      map['cities'] = list;
    }
    return map;
  }

  String get id => _id; //getter
}

class DistrictName extends ApiBaseModel<DistrictName> {
  String sinhala;
  String english;
  String tamil;

  @override
  DistrictName toClass(Map<String, dynamic> map) {
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

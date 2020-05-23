import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/db/dao/city_dao.dart';
import 'package:food_deliver/src/db/dao/district_dao.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';

import 'language_helper.dart';

class CityDistrictHelper{
  String _city;
  String _district;
  final cityId;

  CityDistrictHelper({@required this.cityId}){
    _loadCityDetails(cityId);
  }

  Future<String> getCity() async {
    await _loadCityDetails(cityId);
    return _city;
  }

  Future<String> getDistrict() async {
    await _loadCityDetails(cityId);
    return _district;
  }

  ///get district and city details according to the given city id
  Future<void> _loadCityDetails(String cityID) async {
    try {
      CityEntity cityEntity = await CityDAO()
          .getMatchingEntry(CityEntity(), where: 'cityID = "$cityID"');
      if (cityEntity == null) return Future.value();
      print('nmj city data ${cityEntity.toMap()}');

      DistrictEntity districtEntity = await DistrictDAO().getMatchingEntry(
          DistrictEntity(),
          where: 'ID = "${cityEntity.districtId}"');
      if (districtEntity == null) return Future.value();
      print('nmj district data ${districtEntity.districtName.toString()}');

      _district =
      await LanguageHelper(names: districtEntity.districtName).getName();
      _city = await LanguageHelper(names: cityEntity.name).getName();

    } catch (e) {
      print(e);
    }
    return Future.value();
  }
}
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/city_response_api.dart';
import 'package:food_deliver/src/api/models/response/district_with_cities_response_api.dart';
import 'package:food_deliver/src/db/dao/city_dao.dart';
import 'package:food_deliver/src/db/dao/district_dao.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class CreateDistrictAndCityViewModel extends ChangeNotifier {
  ///execute api call and save district and city details in db
  Future<DistrictWithCitiesResponseApi> retrieveAndSaveDisWithCities(
      BuildContext context) async {
    try {
      //get details of districts and its cities by executing an API call
      DistrictWithCitiesResponseApi responseApi = await APIRequests().execute(
          APIConstants.BASE_URL + APIConstants.API_GET_DISTRICT, context,
          authToken: "",
          responseClass: DistrictWithCitiesResponseApi(),
          apiMethod: ApiMethod.GET);

      if (responseApi == null) return Future.error(null);

      ///save details in db if no any api errors
      if (responseApi.errorBody == null && responseApi.districtList != null) {
        await DistrictDAO().deleteData(DistrictEntity());
        await CityDAO().deleteData(CityEntity());

        for (District district in responseApi.districtList) {
          if (district != null) {
            int districtID = await DistrictDAO()
                .insertData(DistrictEntity().convertToDistrictEntity(district));
            if (districtID != -1) await getAndSaveCities(district, districtID);
          }
        }
        notifyListeners();
        return Future.value(responseApi);
      }

      return Future.value(responseApi);
    } catch (e) {
      print(e);
      return Future.error(null);
    }
  }

  Future<bool> getAndSaveCities(District district, int districtID) async {
    for (CityResponseApi cityResponseApi in district.cities) {
      if (cityResponseApi != null) {
        await CityDAO().insertData(
            CityEntity().convertToCityEntity(cityResponseApi, districtID));
      }
    }
    return Future.value(true);
  }

  Future<DistrictEntity> _getDistrict(String districtID) async {
    try {
      DistrictEntity districtEntity = await DistrictDAO().getMatchingEntry(
          DistrictEntity(),
          where: 'districtID = "' + districtID + '"');
      return districtEntity;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<CityEntity> _getCity(String cityId) async {
    try {
      CityEntity cityEntity = await CityDAO()
          .getMatchingEntry(CityEntity(), where: "cityID = '" + cityId + "'");
      return cityEntity;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///retrieve all records of DistrictEntity in db
  Future<List<DistrictEntity>> getDistrictList() async {
    try {
      List<DistrictEntity> districtEntityList =
          await DistrictDAO().getMatchingEntries(DistrictEntity());
      return districtEntityList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///retrieve all records of CityEntity in db
  Future<List<CityEntity>> getCityList() async {
    try {
      List<CityEntity> cityEntityList =
          await CityDAO().getMatchingEntries(CityEntity());
      return cityEntityList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CityEntity>> getCityListByDistrictId(int districtID) async {
    try {
      List<CityEntity> cityEntityList = await CityDAO().getMatchingEntries(
          CityEntity(),
          where: 'districtID = ?',
          whereArgs: [districtID]);
      return cityEntityList;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

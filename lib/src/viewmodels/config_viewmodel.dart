import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/db/dao/config_dao.dart';
import 'package:food_deliver/src/db/dao/fees_dao.dart';
import 'package:food_deliver/src/db/entity/configurations_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';

//TODO: geesha give this class a proper name
class ConfigViewModel extends ChangeNotifier {
  Future<bool> getAndSaveConfig(BuildContext context) async {
    try {
      ConfigurationResponseApi responseApi = await APIRequests().execute(
          APIConstants.BASE_URL + APIConstants.API_GET_CONFIG, context,
          authToken: "",
          responseClass: ConfigurationResponseApi(),
          apiMethod: ApiMethod.GET);

      if (responseApi == null) return Future.error(false);

      if (!await _saveConfigInDb(responseApi)) return Future.error(false);

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> _saveConfigInDb(ConfigurationResponseApi configResponse) async {
    try {
      if (configResponse.configuration == null) return Future.value(false);

      await ConfigDAO().deleteData(ConfigurationsEntity());
      await FeesDAO().deleteData(FeesEntity());

      int id = await ConfigDAO().insertData(ConfigurationsEntity()
          .convertToConfigEntity(configResponse.configuration));

      configResponse.fees.forEach((fee) {
        _saveFeesInDb(fee, id);
      });

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> _saveFeesInDb(Fee fee, int configID) async {
    try {
      await FeesDAO()
          .insertData(FeesEntity().convertToFeesEntity(fee));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ConfigurationsEntity> _getConfigEntity(String configID) async {
    return await ConfigDAO().getMatchingEntry(ConfigurationsEntity(),
        where: 'configID = "' + configID + '"');
  }

  Future<FeesEntity> _getFeesEntity(String feeID) async {
    return await ConfigDAO()
        .getMatchingEntry(FeesEntity(), where: 'feeID = "' + feeID + '"');
  }
}

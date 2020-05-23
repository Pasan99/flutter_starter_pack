import 'package:food_deliver/src/api/models/response/configuration_response_api.dart';
import 'package:food_deliver/src/db/entity/base_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class ConfigurationsEntity extends BaseEntity<ConfigurationsEntity> {
  int ID;
  int maxCashOrderAmount;
  String configID; //backend config ID;
  String updatedDate;
  String createdDate;

  @override
  ConfigurationsEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('ID')) this.ID = map['ID'];
    if (map.containsKey('maxCashOrderAmount'))
      this.maxCashOrderAmount = map['maxCashOrderAmount'];
    if (map.containsKey('configID')) this.configID = map['configID'];
    if (map.containsKey('updatedDate')) this.updatedDate = map['updatedDate'];
    if (map.containsKey('createdDate')) this.createdDate = map['createdDate'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.maxCashOrderAmount != null)
      map['maxCashOrderAmount'] = this.maxCashOrderAmount;
    if (!this.configID.isInvalid()) map['configID'] = this.configID;
    if (!this.updatedDate.isInvalid()) map['updatedDate'] = this.updatedDate;
    if (!this.createdDate.isInvalid()) map['createdDate'] = this.createdDate;
    return map;
  }

  @override
  String alterTable() {
    return null;
  }

  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID INTEGER PRIMARY KEY' +
        ', maxCashOrderAmount INTEGER ' +
        ', configID TEXT ' +
        ', updatedDate TEXT ' +
        ', createdDate TEXT ' +
        ')';
  }

  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }

  ConfigurationsEntity convertToConfigEntity(Configuration config) {
    if (config == null) return null;

    ConfigurationsEntity configEntity = ConfigurationsEntity();
    if (!config.id.isInvalid()) configEntity.configID = config.id;
    if (config.maxCashOrderAmount != null)
      configEntity.maxCashOrderAmount = config.maxCashOrderAmount;
    if (!config.updatedAt.isInvalid())
      configEntity.updatedDate = config.updatedAt;
    if (!config.createdAt.isInvalid())
      configEntity.createdDate = config.createdAt;
    return configEntity;
  }
}

import 'dart:convert';
import 'package:food_deliver/src/api/models/response/package_response_api.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/package_item.dart';
import 'base_entity.dart';
class PackageEntity extends BaseEntity<PackageEntity> {
  String ID;
  String packageName = "";
  Map<String, dynamic> packageNames;
  List<PackageItem> items;
  String storeId;
  double packageAmount;
  String status;
//  String rejectedReason;
  String stockStatus;
  bool isAddedToCart = false;
  int inCartCount = 1;

  // don't make this zero or null, this will be the default value
  // removing this will case a null exception in UI
  int inventoryCount = 100;

  @override
  String alterTable() {
    return null;
  }
  @override
  String createTable() {
    return 'CREATE TABLE IF NOT EXISTS ' +
        this.runtimeType.toString() +
        '(ID TEXT PRIMARY KEY' +
        ', packageName TEXT ' +
        ', items TEXT' +
        ', storeId TEXT' +
        ', packageAmount REAL' +
        ', status TEXT' +
        ', rejectedReason TEXT' +
        ', stockStatus TEXT' +
        ')';
  }
  @override
  String dropTable() {
    return 'DROP TABLE IF EXISTS ' + this.runtimeType.toString();
  }
  @override
  PackageEntity toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.ID = map['_id'];
    if (map.containsKey('packageName')) this.packageNames = map['packageName'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('packageAmount')) {
      if (map['packageAmount'] is int) {
        this.packageAmount = (map['packageAmount'] as int).toDouble();
      }
      else if (map['packageAmount'] is double){
        this.packageAmount = map['packageAmount'];
      }
    }
    if (map.containsKey('status')) this.status = map['status'];
//    if (map.containsKey('rejectedReason'))
//      this.rejectedReason = map['rejectedReason'];
    if (map.containsKey('stockStatus')) this.stockStatus = map['stockStatus'];
    if (map.containsKey('item') && map['item'] != null) {
      items = List<PackageItem>();
      // used for api
      if (map['item'] is List) {
        List<dynamic> jsonArr = map['item'];
        if (!jsonArr.isInvalid()) {
          jsonArr.forEach((item) {
            items.add(PackageItem().toClass(item));
          });
        }
      }
      // used for localDB
      else {
        List<dynamic> jsonArr = jsonDecode(map['item']);
        if (!jsonArr.isInvalid()) {
          jsonArr.forEach((item) {
            items.add(PackageItem().toClass(item));
          });
        }
      }
    }
    return this;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.ID != null) map['_id'] = this.ID;
    if ((this.packageNames != null)) map['packageName'] = this.packageNames;
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (this.packageAmount != null) map['packageAmount'] = this.packageAmount;
    if (!this.status.isInvalid()) map['status'] = this.status;
//    if (!this.rejectedReason.isInvalid())
//      map['rejectedReason'] = this.rejectedReason;
    if (!this.stockStatus.isInvalid()) map['stockStatus'] = this.stockStatus;
    if (!this.items.isInvalid())
      map['item'] = json.encode(this.items.map((i) => i.toMap()).toList());
    return map;
  }
  PackageEntity toPackageEntity(PackageResponseApi responseApi){
    this.ID = responseApi.Id;
    this.packageNames = responseApi.packageNames;
    this.storeId = responseApi.storeId;
    this.packageAmount = responseApi.packageAmount;
    this.status = responseApi.status;
//    this.rejectedReason = responseApi.rejectedReason;
    this.stockStatus = responseApi.stockStatus;
    this.items = responseApi.items;
    return this;
  }
}
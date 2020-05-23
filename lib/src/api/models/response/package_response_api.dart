import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/models/package_item.dart';
class PackageResponseApi extends ApiBaseModel<PackageResponseApi> {
  String Id;
  String packageName;
  Map<String, dynamic> packageNames;
  String storeId;
  List<PackageItem> items;
  double packageAmount;
  String status;
//  String rejectedReason;
  String stockStatus;
  int inventoryCount;


  @override
  PackageResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('packageId')) this.Id = map['packageId'];
    if (map.containsKey('packageName')) this.packageNames = map['packageName'];
    if (map.containsKey('storeId')) this.storeId = map['storeId'];
    if (map.containsKey('packageAmount'))
      this.packageAmount = map['packageAmount'].toDouble();
    if (map.containsKey('status')) this.status = map['status'];
//    if (map.containsKey('rejectedReason'))
//      this.rejectedReason = map['rejectedReason'];
    if (map.containsKey('stockStatus')) this.stockStatus = map['stockStatus'];
    if (map.containsKey('inventoryCount')) this.inventoryCount = map['inventoryCount'];
    if (map.containsKey('item')) {
      items = List<PackageItem>();
      if (map["item"] is Map) {
        Map<String, dynamic> itemMap = map['item'];
        if (itemMap != null && itemMap.isNotEmpty) {
          items.add(PackageItem().toClass(itemMap));
        }
      } else {
        List<dynamic> jsonArr = map['item'];
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
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.packageNames != null) map['packageName'] = this.packageNames;
    if (!this.storeId.isInvalid()) map['storeId'] = this.storeId;
    if (this.packageAmount != null) map['packageAmount'] = this.packageAmount;
    if (!this.status.isInvalid()) map['status'] = this.status;
//    if (!this.rejectedReason.isInvalid())
//      map['rejectedReason'] = this.rejectedReason;
    if (!this.stockStatus.isInvalid()) map['stockStatus'] = this.stockStatus;
    if (!this.items.isInvalid()) map['items'] = this.items;
    return map;
  }
}
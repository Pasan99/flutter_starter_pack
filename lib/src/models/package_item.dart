import 'dart:convert';

import 'package:food_deliver/src/base/base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class PackageItem extends BaseModel<PackageItem> {
  String Id;
  Map<String, dynamic> productNames;
  String productName = "";
  String qty;

  @override
  toClass(Map<String, dynamic> map) {

    if (map.containsKey('productName')){
      // api
      if (map['productName'] is Map){
        this.productNames = map['productName'];
      }
      // local db
      else{
        this.productNames = jsonDecode(map['productName']);
      }
    }

    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('qty'))
      this.qty = map['qty'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.productNames != null)
      // local db only
      map['productName'] = jsonEncode(this.productNames);
    if (!this.qty.isInvalid()) map['qty'] = this.qty;
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    return map;
  }
}

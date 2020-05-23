
import 'package:food_deliver/src/base/base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class OrderItem extends BaseModel<OrderItem>{
  String packageId;
  String qty;
  double perPackagePrice;
  double total;

  @override
  OrderItem toClass(Map<String, dynamic> map) {
    if (map.containsKey('packageId')) this.packageId = map['packageId'];
    if (map.containsKey('qty'))
      this.qty = map['qty'];
    if (map.containsKey('total')) this.total = map['total'];
    if (map.containsKey('perPackagePrice')) this.perPackagePrice = map['perPackagePrice'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.packageId != null) map['packageId'] = this.packageId;
    if (this.qty != null)
      map['qty'] = this.qty;
    if (this.perPackagePrice != null) map['perPackagePrice'] = this.perPackagePrice;
    if (this.total != null) map['total'] = this.total;
    return map;
  }

  bool isInvalid(){
    if (this.packageId.isInvalid() || this.qty.isInvalid()
        || this.perPackagePrice == null || this.total == null){
      return true;
    }
    return false;
  }
}

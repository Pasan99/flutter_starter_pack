import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class FrequentProductResponseApi extends ApiBaseModel<FrequentProductResponseApi> {
  List<ProductResponseApi> products;

  @override
  FrequentProductResponseApi toClass(Map<String, dynamic> map) {
    FrequentProductResponseApi newInstance = FrequentProductResponseApi();
    if (map.containsKey('products')) {
      newInstance.products = List();
      List<dynamic> jsonArray = map['products'];
      if (!jsonArray.isInvalid()) {
        jsonArray.forEach((product) {
          newInstance.products.add(ProductResponseApi().toClass(product));
        });
      }
    }
    return newInstance;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.products.isInvalid()) {
      List<dynamic> list = List();
      this.products.forEach((product) {
        list.add(product.toMap());
      });
      map['fees'] = list;
    }

    return map;
  }
}
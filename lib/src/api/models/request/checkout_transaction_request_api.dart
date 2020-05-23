import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class CheckoutTransactionRequestAPI extends ApiBaseModel<CheckoutTransactionRequestAPI> {
  String merchantId;
  List<CheckoutProductRequestApi> lineItems;

  CheckoutTransactionRequestAPI(
      {this.merchantId, this.lineItems});

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('merchantId')) this.merchantId = map['merchantId'];

    if (map.containsKey('lineItems')) {
      lineItems = List();
      List<dynamic> jsonArr = map['lineItems'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((package) {
          lineItems.add(CheckoutProductRequestApi().toClass(package));
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.merchantId != null) map['merchantId'] = this.merchantId;
    if (!this.lineItems.isInvalid()) {
      var newProduct = lineItems.map((product)=> product.toMap()).toList();
      map['lineItems'] = newProduct;
    }
    return map;
  }
}

class CheckoutProductRequestApi extends ApiBaseModel<CheckoutProductRequestApi>{
  String productId;
  num qty;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('productId')) this.productId = map['productId'];
    if (map.containsKey('qty')) this.qty = map['qty'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (this.productId != null) map['productId'] = this.productId;
    if (this.qty != null) map['qty'] = this.qty;
    return map;
  }

  CheckoutProductRequestApi toCheckoutProduct(CartItemEntity cartItem){
    CheckoutProductRequestApi newProduct = CheckoutProductRequestApi();
    newProduct.productId = cartItem.product.Id;
    newProduct.qty = cartItem.quantity;
    return newProduct;
  }
}

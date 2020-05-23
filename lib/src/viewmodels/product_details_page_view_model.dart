import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/dummy_data_provider.dart';

class ProductDetailsViewModel with ChangeNotifier{
  List<ProductEntity> suggestedProducts;
  int cartItemsCount = 0;

  ProductDetailsViewModel(){
    getCartItemCount();
  }

  getCartItemCount() async {
    cartItemsCount = await CartHelper().getCartItemCount();
    notifyListeners();
  }

  Future<CartResponses> addToCart(ProductEntity product) async {
    CartResponses response = await CartHelper().addToCart(product);
    await getCartItemCount();
    return response;
  }

  Future<CartResponses> updateItem(ProductEntity product) async {
    CartResponses response = await CartHelper().updateCartItem(product);
    await getCartItemCount();
    return response;
  }

  Future<CartResponses> removeItem(ProductEntity product) async {
    CartResponses response = await CartHelper().removeFromCart(product);
    await getCartItemCount();
    return response;
  }

  getSuggestedProducts() async {
    suggestedProducts = List();
    suggestedProducts = DummyDataProvider.setTopProductsDummyData();
    notifyListeners();

    // check whether the products are added to cart or not
    List<String> inCartProducts = await CartHelper().getProductIds();
    List<CartItemEntity> cartItems = await CartHelper().getCartItems();
    if (inCartProducts.length > 0) {
      suggestedProducts.forEach((item) {
        if (inCartProducts.contains(item.Id)) {
          item.inCartCount =
              cartItems[inCartProducts.indexOf(item.Id)].quantity;
          item.isAddedToCart = true;
        }
      });

      notifyListeners();
    }
  }
}
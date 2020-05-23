import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/dummy_data_provider.dart';

class StoreCategoryBasedViewModel with ChangeNotifier{
  List<ProductEntity> products;
  int cartItemsCount = 0;
  StoreResponseApi storeResponseApi;
  CategoryResponseApi categoriesModel;

  StoreCategoryBasedViewModel(BuildContext context, StoreResponseApi storeResponseApi, CategoryResponseApi categoriesModel){
    this.categoriesModel = categoriesModel;
    this.storeResponseApi = storeResponseApi;
    getAllProducts(context);
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

  Future<CartResponses> removeItem(ProductEntity product) async {
    CartResponses response = await CartHelper().removeFromCart(product);
    await getCartItemCount();
    return response;
  }

  getAllProducts(BuildContext context) async {
    products = List();

    /// change store Id in API request to category Id
    /// categoriesModel.Id instead on storeResponseApi.Id

    try {
      // get Data from the api
      APIRequests request = APIRequests();
      List<ProductResponseApi> result = await request.getList(
          APIConstants.BASE_URL_2 + APIConstants.API_GET_STORE_CATEGORIES_BY_CATEGORY +
              "${categoriesModel.Id}/${storeResponseApi.Id}",
          context,
          authToken: "",
          body: "",
          responseClass: ProductResponseApi());
      print(result);

      // convert
      products = convertProductResponseToEntity(result);
      notifyListeners();

      // check whether the products are added to cart or not
      List<String> inCartProducts = await CartHelper().getProductIds();
      List<CartItemEntity> cartItems = await CartHelper().getCartItems();
      if (products != null && products.length > 0 && inCartProducts != null && inCartProducts.length > 0) {
        products.forEach((item) {
          if (inCartProducts.contains(item.Id)) {
            item.inCartCount =
                cartItems[inCartProducts.indexOf(item.Id)].quantity;
            item.isAddedToCart = true;
          }
        });

        notifyListeners();
      }
    }
    catch(i){

    }
  }

  List<ProductEntity> convertProductResponseToEntity(List<ProductResponseApi> productResponses){
    List<ProductEntity> entities = List();
    if (productResponses != null){
      productResponses.forEach((response) async {
        entities.add( await ProductEntity().toProductEntity(response));
      });
    }
    return entities;
  }
}
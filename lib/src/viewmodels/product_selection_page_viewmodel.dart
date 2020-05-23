import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/frequent_product_response.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/dummy_data_provider.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class ProductSelectionPageViewModel with ChangeNotifier{
  List<CategoryResponseApi> categories;
  List<ProductEntity> products;
  List<ProductEntity> topProducts;
  int cartItemsCount = 0;
  StoreResponseApi storeResponseApi;
  Responses currentResponseGetProducts = Responses.ONGOING;
  BuildContext context;

  // pagination
  int currentCategoryPage = 1;
  final categoryPageSize = 10;
  final productPageSize = 10;
  int currentProductPage = 1;
  int allProductsCount = 1;

  ProductSelectionPageViewModel(BuildContext context, StoreResponseApi storeResponseApi){
    this.context = context;
    this.storeResponseApi = storeResponseApi;
//    storeResponseApi.Id = "5e8f1d339a4e5977278c340b";
    getCategoryItems(context);
    getTopProducts(context);
    getAllProducts(context);
    getCartItemCount();
  }

  retry(){
    getCategoryItems(context);
    getTopProducts(context);
    getAllProducts(context);
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

  Future<Responses> getCategoryItems(BuildContext context) async {
    categories = List();
    try {
      // get Data from the api
      APIRequests request = APIRequests();
      List<CategoryResponseApi> result = await request.getList(
          APIConstants.BASE_URL_2 + APIConstants.API_GET_CATEGORIES +
              "/${storeResponseApi.Id}?page=$currentCategoryPage&size=$categoryPageSize",
          context,
          authToken: "",
          body: "",
          responseClass: CategoryResponseApi());
      //categories = DummyDataProvider.setCategoryDummyData();
      categories = result;
      notifyListeners();
      currentCategoryPage++;
      if (result != null){
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    }
    catch(i){
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  Future<Responses> getAllProducts(BuildContext context) async {
    products = List();
    try {
      // get Data from the api
      APIRequests request = APIRequests();
      List<ProductResponseApi> result = await request.getList(
          APIConstants.BASE_URL_2 + APIConstants.API_GET_PRODUCTS +
              "/${storeResponseApi.Id}?page=$currentProductPage&size=$productPageSize",
          context,
          authToken: "",
          body: "",
          responseClass: ProductResponseApi());
      print(result);

      // convert
      products = convertProductResponseToEntity(result);
//      products = DummyDataProvider.setProductsDummyData();
//      allProductsCount = products.length;
      notifyListeners();

      // check whether the products are added to cart or not
      List<String> inCartProducts = await CartHelper().getProductIds();
      List<CartItemEntity> cartItems = await CartHelper().getCartItems();
      if (products != null && products.length > 0 && inCartProducts != null && inCartProducts.length > 0) {
        products.forEach((item) {
          if (item.storeMaxOrderLimit == null ) item.storeMaxOrderLimit = storeResponseApi.maxOrderAmount;
          print(item.storeMaxOrderLimit);
          if (inCartProducts.contains(item.Id)) {
            item.inCartCount =
                cartItems[inCartProducts.indexOf(item.Id)].quantity;
            item.isAddedToCart = true;
          }
        });

        notifyListeners();
      }
      if ( result != null && result.length > 0 && result[0].errorBody == null){
        allProductsCount = result[0].total != null ? result[0].total : products.length;
        currentResponseGetProducts = Responses.DATA_RETRIEVED;
        notifyListeners();
        return Responses.DATA_RETRIEVED;
      }
      currentResponseGetProducts = Responses.NO_DATA;
      notifyListeners();
      return Responses.NO_DATA;
    }
    catch(i){
      print(i);
      currentResponseGetProducts = Responses.NETWORK_DISCONNECTED;
      notifyListeners();
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  Future<Responses> getTopProducts(BuildContext context) async {
    topProducts = List();
    try {
      // get Data from the api
      APIRequests request = APIRequests();
      FrequentProductResponseApi response = await request.execute(
          APIConstants.BASE_URL_2 + APIConstants.API_GET_TOP_PRODUCTS +
              "/${storeResponseApi.Id}",
          context,
          authToken: "",
          body: "",
          apiMethod: ApiMethod.GET,
          responseClass: FrequentProductResponseApi());

      List<ProductResponseApi> result = response.products;
      topProducts = convertProductResponseToEntity(result);
//      topProducts = DummyDataProvider.setTopProductsDummyData();
      notifyListeners();

      // check whether the products are added to cart or not
      List<String> inCartProducts = await CartHelper().getProductIds();
      List<CartItemEntity> cartItems = await CartHelper().getCartItems();
      if (inCartProducts != null && inCartProducts.length > 0) {
        topProducts.forEach((item) {
          if (inCartProducts.contains(item.Id)) {
            item.inCartCount =
                cartItems[inCartProducts.indexOf(item.Id)].quantity;
            item.isAddedToCart = true;
          }
        });

        notifyListeners();
      }
      if ( result != null && result[0].errorBody == null && result.length > 0){
        allProductsCount = result[0].total != null ? result[0].total : products.length;
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    }
    catch(i){
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  Future<bool> loadCategories() async {
    Responses response;
    if (categories!= null && categories[0].total != categories.length) {
      response = await getCategoryItems(context);
      currentResponseGetProducts = response;
      print("Load More");
    }
    if (response == Responses.DATA_RETRIEVED){
      return true;
    }
    return false;
  }

  Future<bool> loadProducts() async {
    Responses response;
    if (topProducts!= null && allProductsCount != topProducts.length) {
      response = await getAllProducts(context);
      currentResponseGetProducts = response;
      print("Load More");
    }
    if (response == Responses.DATA_RETRIEVED){
      return true;
    }
    return false;
  }


  List<ProductEntity> convertProductResponseToEntity(List<ProductResponseApi> productResponses){
    List<ProductEntity> entities = List();
    if (productResponses != null){
      productResponses.forEach((response) async {
        entities.add(await ProductEntity().toProductEntity(response));
      });
    }
    return entities;
  }
}
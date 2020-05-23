import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/search_request_api.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/dummy_data_provider.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class ProductSearchViewModel with ChangeNotifier {
  ProductSearchType searchType;
  List<ProductEntity> searchList;
  TextEditingController searchEditor = TextEditingController();
  BuildContext context;
  String merchantId;
  String categoryId;

  ProductSearchViewModel(
      {@required this.merchantId, @required this.categoryId, this.context, this.searchType});

  getSearchList(String query) async {
    searchList = List();
    if (searchType == ProductSearchType.InStoreSearch) {
      await getInStoreSearchResult(query);
    } else if (searchType == ProductSearchType.CategorySearch) {
      await getCategoryBasedProductSearch(query);
    }

    // check whether the products are added to cart or not
    List<String> inCartProducts = await CartHelper().getProductIds();
    List<CartItemEntity> cartItems = await CartHelper().getCartItems();
    if (searchList != null &&
        searchList.length > 0 &&
        inCartProducts != null &&
        inCartProducts.length > 0) {
      searchList.forEach((item) {
        if (inCartProducts.contains(item.Id)) {
          item.inCartCount =
              cartItems[inCartProducts.indexOf(item.Id)].quantity;
          item.isAddedToCart = true;
        }
      });
    }
    notifyListeners();
  }

  Future<Responses> getInStoreSearchResult(String query) async {
    merchantId = "5e8f1d339a4e5977278c340b";
    //searchList = DummyDataProvider.setProductsDummyData();
    try {
      // get Data from the api
      SearchRequestApi searchRequest = SearchRequestApi();
      searchRequest.index = "productss";
      searchRequest.body = searchRequest.createSearchBody(
        searchType: ProductSearchType.InStoreSearch,
          query: query, id: merchantId, from: 0, size: 10);

      APIRequests request = APIRequests();
      List<ProductResponseApi> result = await request.getList(
          APIConstants.BASE_URL_P +
              APIConstants.API_SEARCH +
              APIConstants.API_IN_STORE,
          context,
          authToken: "",
          body: jsonEncode(searchRequest.toMap()),
          apiMethod: ApiMethod.POST,
          responseClass: ProductResponseApi());
      //categories = DummyDataProvider.setCategoryDummyData();
      print("Hello");
      result.forEach((response) async {
        searchList.add(await ProductEntity().toProductEntity(response));
      });
      notifyListeners();
      if (result != null) {
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    } catch (i) {
      print(i);
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  Future<void> getCategoryBasedProductSearch(String query) async {
    //searchList = DummyDataProvider.setProductsDummyData();
    try {
      // get Data from the api
      SearchRequestApi searchRequest = SearchRequestApi();
      searchRequest.index = "productss";
      searchRequest.body = searchRequest.createSearchBody(
        searchType: ProductSearchType.CategorySearch,
          query: query, id: categoryId, from: 0, size: 10);

      APIRequests request = APIRequests();
      List<ProductResponseApi> result = await request.getList(
          APIConstants.BASE_URL_P +
              APIConstants.API_SEARCH +
              APIConstants.API_CATEGORY,
          context,
          authToken: "",
          body: jsonEncode(searchRequest.toMap()),
          apiMethod: ApiMethod.POST,
          responseClass: ProductResponseApi());
      //categories = DummyDataProvider.setCategoryDummyData();
      print("Hello");
      if (result == null || result.length == 0){
        searchList.clear();
      }
      else{
        result.forEach((response) async {
          searchList.add(await ProductEntity().toProductEntity(response));
        });
      }
      notifyListeners();
      if (result != null) {
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    } catch (i) {
      notifyListeners();
      print(i);
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  clearSearchList() {
    searchList.clear();
    notifyListeners();
  }

  Future<CartResponses> addToCart(ProductEntity product) async {
    CartResponses response = await CartHelper().addToCart(product);
    return response;
  }

  Future<CartResponses> updateItem(ProductEntity product) async {
    CartResponses response = await CartHelper().updateCartItem(product);
    return response;
  }

  Future<CartResponses> removeItem(ProductEntity product) async {
    CartResponses response = await CartHelper().removeFromCart(product);
    return response;
  }
}

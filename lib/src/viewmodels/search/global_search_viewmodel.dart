import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/request/global_store_search_request_api.dart';
import 'package:food_deliver/src/api/models/request/search_request_api.dart';
import 'package:food_deliver/src/api/models/response/product_response_api.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class GlobalSearchViewModel with ChangeNotifier {
  List<ProductEntity> searchList;
  List<StoreResponseApi> storeSearchList;


  TextEditingController searchEditor = TextEditingController();
  BuildContext context;
  int selectedIndex;

  String merchantId;

  GlobalSearchViewModel({this.context});

  onChangeSearchSelector(int index){
    selectedIndex = index;
    notifyListeners();
    if (index == 0){
      // store search
      getStoreSearchList(searchEditor.text.toString());
    }
    else{
      // product search
      getProductSearchList(searchEditor.text.toString());
      print("selectedIndex : $selectedIndex");
    }
  }

  onTextChange(){
    onChangeSearchSelector(selectedIndex == null ? 0 : selectedIndex);
  }

  getProductSearchList(String query) async {
    searchList = List();
    executeProductSearchApi(query);
    notifyListeners();

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

  Future<Responses> getStoreSearchList(String query) async {
    merchantId = "5e8f1d339a4e5977278c340b";
    //searchList = DummyDataProvider.setProductsDummyData();
    UserEntity currentUser = await UserAuth().getCurrentUser();
    try {
      // get Data from the api
      GlobalStoreSearchRequestApi searchRequest = GlobalStoreSearchRequestApi(
        query: query,
        gpsCoordinates: currentUser.gpsCoordinates.coordinates,
        size: 10,
        from: 0
      );

      APIRequests request = APIRequests();
      storeSearchList = await request.getList(
          APIConstants.BASE_URL_P +
              APIConstants.API_SEARCH +
              APIConstants.API_STORE_SEARCH,
          context,
          authToken: "",
          body: jsonEncode(searchRequest.toMap()),
          apiMethod: ApiMethod.POST,
          responseClass: StoreResponseApi());
      storeSearchList.forEach((store) async {
        store.storeName = await LanguageHelper(names: store.storeNames).getName();
      });

      notifyListeners();
      if (storeSearchList != null) {
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    } catch (i) {
      print(i);
      return Responses.NETWORK_DISCONNECTED;
    }
  }


  Future<Responses> executeProductSearchApi(String query) async {
    merchantId = "5e8f1d339a4e5977278c340b";
    //searchList = DummyDataProvider.setProductsDummyData();
    try {
      // get Data from the api
      SearchRequestApi searchRequest = SearchRequestApi();
      searchRequest.index = "productss";
      searchRequest.body = searchRequest.createSearchBody(
          searchType: ProductSearchType.InStoreSearch,
          query: query,
          id: merchantId,
          from: 0,
          size: 10);

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

  clearSearchList() {
    searchList.clear();
    storeSearchList.clear();
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

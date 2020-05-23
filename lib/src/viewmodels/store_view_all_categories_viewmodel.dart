import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class StoreViewAllCategoriesViewModel with ChangeNotifier {
  List<CategoryResponseApi> categories;
  int currentCategoryPage = 1;
  final int categoryPageSize = 10;
  StoreResponseApi storeResponseApi;

  BuildContext context;

  StoreViewAllCategoriesViewModel({ this.context, this.storeResponseApi}) {
    getCategoryItems();
  }

  Future<Responses> getCategoryItems() async {
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
      if (result != null) {
        return Responses.DATA_RETRIEVED;
      }
      return Responses.NO_DATA;
    } catch (i) {
      return Responses.NETWORK_DISCONNECTED;
    }
  }

  Future<bool> loadCategories() async {
    Responses response;
    if (categories != null && categories[0].total != categories.length) {
      response = await getCategoryItems();
      print("Load More");
    }
    if (response == Responses.DATA_RETRIEVED) {
      return true;
    }
    return false;
  }
}

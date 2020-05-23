import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/utills/dummy_data_provider.dart';
import 'package:food_deliver/src/utills/response_codes.dart';

class ViewAllCategoriesViewModel with ChangeNotifier{
  List<CategoryResponseApi> categories;
  int currentCategoryPage = 1;
  final int categoryPageSize = 10;

  BuildContext context;

  ViewAllCategoriesViewModel(BuildContext context){
    this.context = context;
    getCategoryItems();
  }

  Future<Responses> getCategoryItems() async {
    categories = List();
    try {
      // get Data from the api
      APIRequests request = APIRequests();
      List<CategoryResponseApi> result = await request.getList(
          APIConstants.BASE_URL_2 + APIConstants.API_GET_MASTER_CATEGORIES,
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

  Future<bool> loadCategories() async {
    Responses response;
    if (categories!= null && categories[0].total != categories.length) {
      response = await getCategoryItems();
      print("Load More");
    }
    if (response == Responses.DATA_RETRIEVED){
      return true;
    }
    return false;
  }
}
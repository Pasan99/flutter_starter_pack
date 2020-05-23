import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/api/api_constants.dart';
import 'package:food_deliver/src/api/api_requests.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/home_response_api.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/handlers/contact_sync_handler.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class HomeFragmentViewModel with ChangeNotifier {
  List<PosterResponseApi> carouselImages;
  List<CategoryResponseApi> categories;
  List<StoreResponseApi> stores;

  bool isCarouselImageLoaded = false;
  BuildContext context;

  HomeFragmentViewModel(BuildContext context) {
    this.context = context;
    getData();
  }

  getData() async {
    carouselImages = List();
    categories = List();
    stores = List();
    try {
      // get Data from the api
      await ContactSyncHandler().syncContacts(context);
      UserEntity currentUser = await UserAuth().getCurrentUser();
      APIRequests request = APIRequests();
      HomeResponseApi result = await request.execute(
          APIConstants.BASE_URL_P +
              APIConstants.API_GET_HOME_PAGE +
              "?lng=${currentUser.gpsCoordinates.coordinates[0]}&lat=${currentUser.gpsCoordinates.coordinates[1]}",
//              "?lng=79.86133555273437&lat=9.861244",
          context,
          authToken: "",
          body: "",
          apiMethod: ApiMethod.GET,
          responseClass: HomeResponseApi());
      print(result);

      result.stores.forEach((store) async {
        if (store.storeNames != null){
          store.storeName = await LanguageHelper(names: store.storeNames).getName();
        }
        if (store.cityNames != null){
          store.cityName = await LanguageHelper(names: store.cityNames).getName();
        }
      });

      if (result != null && result.errorBody == null) {
        carouselImages = result.posters;
        categories = result.categories;
        stores = result.stores;
        isCarouselImageLoaded = true;
      }
    } catch (i) {
      print(i);
    }
    notifyListeners();
  }
}

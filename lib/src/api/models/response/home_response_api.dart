import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

class HomeResponseApi extends ApiBaseModel<HomeResponseApi>{
  List<PosterResponseApi> posters;
  List<CategoryResponseApi> categories;
  List<StoreResponseApi> stores;

  @override
  HomeResponseApi toClass(Map<String, dynamic> map) {

    if (map.containsKey('poster')) {
      posters = List();
      List<dynamic> jsonArr = map['poster'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((poster) {
          posters.add(PosterResponseApi().toClass(poster));
        });
      }
    }

    if (map.containsKey('masterCategories')) {
      categories = List();
      List<dynamic> jsonArr = map['masterCategories'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((category) {
          categories.add(CategoryResponseApi().toClass(category));
        });
      }
    }

    if (map.containsKey('stores')) {
      stores = List();
      List<dynamic> jsonArr = map['stores'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((store) {
          stores.add(StoreResponseApi().toClass(store));
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    return null;
  }

}

class PosterResponseApi extends ApiBaseModel<PosterResponseApi>{
  String Id;
  String imageUrl;
  int sequenceNumber;
  String ctaUrl;

  @override
  PosterResponseApi toClass(Map<String, dynamic> map) {
    if (map.containsKey('_id')) this.Id = map['_id'];
    if (map.containsKey('imageUrl')) this.imageUrl = map['imageUrl'];
    if (map.containsKey('sequenceNumber')) this.sequenceNumber = map['sequenceNumber'];
    if (map.containsKey('ctaUrl')) this.ctaUrl = map['ctaUrl'];
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    return null;
  }
}

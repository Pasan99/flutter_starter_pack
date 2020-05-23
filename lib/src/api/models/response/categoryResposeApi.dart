import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
class CategoryResponseApi extends ApiBaseModel<CategoryResponseApi> {
  String Id;
  String name;
  Map<String, dynamic> categoryNames;
  String description;
  int count;
  int activeProducts;
  bool isGlobal;
  String imageUrl;

  int pages;
  int total;

  CategoryResponseApi({ this.imageUrl, this.name, this.Id});

  @override
  CategoryResponseApi toClass(Map<String, dynamic> map) {
    CategoryResponseApi newInstance = CategoryResponseApi();

    if (map.containsKey('total')) newInstance.total = map['total'];
    if (map.containsKey('pages')) newInstance.pages = map['pages'];

    if (map.containsKey('_id')) newInstance.Id = map['_id'];
    if (map.containsKey('name')) newInstance.name = map['name'];
    if (map.containsKey('localizedNames')) newInstance.categoryNames = map['localizedNames'];
    if (map.containsKey('description')) newInstance.description = map['description'];
    if (map.containsKey('count')) newInstance.count = map['count'];
    if (map.containsKey('activeProducts')) newInstance.activeProducts = map['activeProducts'];
    if (map.containsKey('isGlobal')) newInstance.isGlobal = map['isGlobal'];
    if (map.containsKey('imageUrl')) newInstance.imageUrl = map['imageUrl'];
    return newInstance;
  }
  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.Id.isInvalid()) map['_id'] = this.Id;
    if (this.name != null) map['name'] = this.name;
    if (this.categoryNames != null) map['localizedNames'] = this.categoryNames;
    if (this.description != null) map['description'] = this.description;
    if (this.count != null) map['count'] = this.count;
    if (this.activeProducts != null) map['activeProducts'] = this.activeProducts;
    if (this.isGlobal != null) map['isGlobal'] = this.isGlobal;
    if (this.imageUrl != null) map['imageUrl'] = this.imageUrl;
    return map;
  }
}
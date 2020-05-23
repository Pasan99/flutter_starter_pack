import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ui/pages/search/product_search_page.dart';

class SearchRequestApi extends ApiBaseModel<SearchRequestApi> {
  String index;
  SearchBodyRequestApi body;

  @override
  SearchRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.index.isInvalid()) map['index'] = this.index;
    if (this.body != null) map['body'] = this.body.toMap();
    return map;
  }

  SearchBodyRequestApi createSearchBody(
      {String query, String id, int from, int size, @required ProductSearchType searchType}) {
    SearchBodyRequestApi body = SearchBodyRequestApi();
    body.from = from != null ? from : 0;
    body.size = size != null ? size : 10;
    body.query = SearchQueryRequestApi(
        bool_1: SearchBoolRequestApi(must: [
      SearchMatchingQueryRequestApi(matchPhrasePrefix: query),
          SearchMatchingRequestApi(id: id, searchType: searchType)
    ]));
    return body;
  }
}

class SearchBodyRequestApi extends ApiBaseModel<SearchBodyRequestApi> {
  SearchQueryRequestApi query;
  num from;
  num size;

  @override
  SearchBodyRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();

    if (query != null) map['query'] = this.query.toMap();
    if (from != null) map['from'] = this.from;
    if (size != null) map['size'] = this.size;

    return map;
  }
}

class SearchQueryRequestApi extends ApiBaseModel<SearchQueryRequestApi> {
  SearchBoolRequestApi bool_1;

  SearchQueryRequestApi({this.bool_1});

  @override
  SearchQueryRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (bool_1 != null) map['bool'] = this.bool_1.toMap();
    return map;
  }
}

class SearchBoolRequestApi extends ApiBaseModel<SearchBoolRequestApi> {
  List<ApiBaseModel> must;

  SearchBoolRequestApi({this.must});

  @override
  SearchBoolRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.must.isInvalid()) {
      var newInstance = must.map((search) => search.toMap()).toList();
      map['must'] = newInstance;
    }
    return map;
  }
}

class SearchMatchingQueryRequestApi
    extends ApiBaseModel<SearchMatchingQueryRequestApi> {
  String matchPhrasePrefix;

  SearchMatchingQueryRequestApi({this.matchPhrasePrefix});

  @override
  SearchMatchingQueryRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (!this.matchPhrasePrefix.isInvalid())
      map['match_phrase_prefix'] = {
        "name": {"query": matchPhrasePrefix}
      };

    return map;
  }
}

class SearchMatchingRequestApi
    extends ApiBaseModel<SearchMatchingQueryRequestApi> {
  String id;
  ProductSearchType searchType;

  SearchMatchingRequestApi({this.id, @required this.searchType});

  @override
  SearchMatchingRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    if (searchType == ProductSearchType.InStoreSearch) {
      if (!this.id.isInvalid())
        map['match'] = {"merchantId": id.toString()};
    }
    else if (searchType == ProductSearchType.CategorySearch) {
      if (!this.id.isInvalid())
        map['match'] = {"categoryId": id.toString()};
    }

    return map;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/base/api_base_model.dart';

class GlobalStoreSearchRequestApi extends ApiBaseModel<GlobalStoreSearchRequestApi> {
  String query;
  List<double> gpsCoordinates;
  int from;
  int size;

  GlobalStoreSearchRequestApi({@required this.query, @required this.gpsCoordinates, this.from = 0, this.size = 10});

  @override
  GlobalStoreSearchRequestApi toClass(Map<String, dynamic> map) {
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    Map<String, dynamic> map = Map();
    map['body'] = {
      "from": from,
      "size": size,
      "query": {"bool": {
        "must" : [
          {
            "multi_match":{
              "query":"$query",
              "fields":[
                "storeName.sinhala",
                "storeName.english",
                "storeName.tamil"
              ],
              "type":"phrase_prefix"
            }
          },
          {
            "geo_shape":{
              "gpsCoordinates":{
                "shape":{
                  "type":"circle",
                  "radius":"500000m",
                  "coordinates": [gpsCoordinates[1], gpsCoordinates[0]]
                }
              }
            }
          }
        ]
      }}
    };
    return map;
  }
}

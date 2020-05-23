import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/values/strings.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class CarouselStoreItem extends StatelessWidget {
  StoreResponseApi card;
  int progress = 0;

  CarouselStoreItem({this.card});

  @override
  Widget build(BuildContext context) {
    if (card != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
        child: Container(
          child: Material(
            color: AppColors.BACK_WHITE_COLOR,
            elevation: 14.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: AppColors.MAIN_COLOR,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 4, 20),
                          child: Text(
                            card.storeName != null ? card.storeName : "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.TEXT_WHITE),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Container(
                        height: 20.0,
                        width: 1.0,
                        color: Colors.white30,
                        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 24, 20),
                          child: Text(
                            card.cityName != null ? card.cityName : "",
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 14),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CachedNetworkImage(
                  imageUrl: card.storeImageURL != null ? card.storeImageURL : "",
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/factory_illustration.png",
                    height: 150.0,
                  ),
                  placeholder: (context, url) =>
                      SizedBox(
                        height: 150.0,
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                            child: Text(
                                Strings.APP_NAME,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
//                progressIndicatorBuilder: (context, url, downloadProgress) =>
//                    CircularProgressIndicator(value: downloadProgress.progress),
//                loadingBuilder: (BuildContext context, Widget child,
//                    ImageChunkEvent loadingProgress) {
//                  if (loadingProgress == null) return child;
//                  return Center(
//                    child: Center(
//                      child: SpinKitPulse(
//                        color: AppColors.MAIN_COLOR,
//                        size: 150.0,
//                      ),
//                    ),
//                  );
//                },
                  height: 150,
                  width: 500,
                  fit: BoxFit.cover,
                ),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 4, 24),
                    child: Icon(
                      CupertinoIcons.location_solid,
                      color: AppColors.LIGHT_MAIN_COLOR,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                      child: Text(
                        "${card.street != null ? card.street + "," : ""} "
                            "${card.mainRoad != null
                            ? card.mainRoad + ","
                            : ""} "
                            "${card.cityName != null ? card.cityName : ""}",
                        style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ]),

//              Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                child: Divider(
//                  height: 1,
//                  color: AppColors.DIVIDER_COLOR,
//                ),
//              ),

//              Row(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.fromLTRB(24, 8, 4, 0),
//                    child: Text(
//                      "Openning Hours",
//                      style:
//                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.fromLTRB(4, 8, 24, 0),
//                    child: Text(
//                      "9AM - 6PM",
//                      style:
//                          TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
//                    ),
//                  ),
//                ],
//              ),
//              Row(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.fromLTRB(24, 4, 4, 24),
//                    child: Text(
//                      "Category",
//                      style:
//                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                    ),
//                  ),
//                  Expanded(
//                    child: Padding(
//                      padding: const EdgeInsets.fromLTRB(4, 4, 24, 24),
//                      child: Text(
//                        "Groceries | Vegetables | Fruits | Pharmacy",
//                        style:
//                            TextStyle(fontWeight: FontWeight.w200, fontSize: 12),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return Container(
        key: Key("Empty"),
      );
    }
  }
}

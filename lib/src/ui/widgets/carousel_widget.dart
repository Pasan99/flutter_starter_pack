import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/home_response_api.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/values/strings.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class CustomCarousel extends StatelessWidget {
  final List<PosterResponseApi> carousels;
  final bool isBackgroundEnabled;
  final int maxItemCount = 5;
  List<PosterResponseApi> trimmedCarousels;

  CustomCarousel({Key key, @required this.carousels, this.isBackgroundEnabled}) {
    if (carousels.length >= maxItemCount) {
      trimmedCarousels = carousels.sublist(0, maxItemCount);
    }
    else{
      trimmedCarousels = carousels;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isBackgroundEnabled == null || isBackgroundEnabled ? BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.MAIN_COLOR, Colors.white])) : null,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: CarouselSlider(
            options : CarouselOptions(
              height: 266.0,
              enableInfiniteScroll: true,
              autoPlay: true,
              aspectRatio: 16/9,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: trimmedCarousels.map((model) {
              return Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,16),
                    child: Material(
                      elevation: 8,
                      color: AppColors.BACK_WHITE_COLOR,
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: <Widget>[
                          CachedNetworkImage(
                            fadeInCurve: Curves.easeIn,
                            imageUrl: model.imageUrl != null ? model.imageUrl : "",
                            errorWidget: (context, url, error) => Image.asset(
                                "assets/images/shopping_illustration.png",
                              width: 500,
                              height: 250.0,
                            ),
                            placeholder: (context, url) =>
                                SizedBox(
                                  height: 250.0,
                                  width: 500,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.black12,
                                    highlightColor: Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
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
                            height: 250,
                            width: 500,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class CarouselModel{
  final String image;
  final String link;

  CarouselModel({this.image, this.link});
}
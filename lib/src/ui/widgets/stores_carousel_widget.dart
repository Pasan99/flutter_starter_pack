import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/store_response_api.dart';
import 'package:food_deliver/src/ui/widgets/carousel_store_item.dart';

// ignore: must_be_immutable
class StoresCarousel extends StatelessWidget {
  final List<StoreResponseApi> stores;
  List<StoreResponseApi> trimmedStores;
  final int maxItemCount = 5;
  final Function onClick;

  StoresCarousel({Key key, @required this.stores, this.onClick}){
    if (stores.length >= maxItemCount) {
      trimmedStores = stores.sublist(0, maxItemCount);
    }
    else{
      trimmedStores = stores;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CarouselSlider(
            options : CarouselOptions(
              enableInfiniteScroll: false,
              autoPlay: true,
              height: 310,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: trimmedStores.map((model) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: (){
                      onClick(model);
                    },
                    child: CarouselStoreItem(
                      card: model,
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
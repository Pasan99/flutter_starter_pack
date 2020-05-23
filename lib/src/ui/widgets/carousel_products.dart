import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/widgets/product_item.dart';

// ignore: must_be_immutable
class ProductsCarousel extends StatelessWidget {
  final List<ProductEntity> products;
  List<ProductEntity> trimmedProducts;
  final Function onCartItemChanged;
  final Function onCartItemRemoved;
  final Function onCartPressed;
  final int maxItemCount = 5;

  ProductsCarousel({Key key, @required this.products, this.onCartItemChanged, this.onCartItemRemoved, this.onCartPressed}) {
    if (products.length >= maxItemCount) {
      trimmedProducts = products.sublist(0, maxItemCount);
    }
    else{
      trimmedProducts = products;
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
              height: 180,
              enlargeCenterPage: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            items: trimmedProducts.sublist(0, 4).map((model) {
              return Builder(
                builder: (BuildContext context) {
                  return ProductItem(
                    onCartPressed: onCartPressed,
                    //////////////////// On remove Item /////////////////////////////
                    onRemoveFromCart: (){
                      model.isAddedToCart = false;
                      if (onCartItemRemoved != null) {
                        onCartItemRemoved(model);
                      }
                    },
                    //////////////////// On Changed Item /////////////////////////////
                    onCartItemChanged: (value){
                      model.isAddedToCart = true;
                      model.inCartCount = value;
                      if (onCartItemChanged != null) {
                        onCartItemChanged(model);
                      }
                    },
                    productEntity: model,

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
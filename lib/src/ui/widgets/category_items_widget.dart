import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItems extends StatelessWidget {
  final List<CategoryResponseApi> categories;
  final Function onCartPressed;
  final Function onPressed;

  const CategoryItems({Key key, @required this.categories, this.onCartPressed, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      shrinkWrap: true,
      ///////////////////
      children: categories != null ? categories.map((category){
        return category != null ? GestureDetector(
          onTap: (){
            if (onPressed == null) {
              ExtendedNavigator.of(context).pushNamed(
                  Routes.categoryBasedStoreSelectionPage,
                  arguments: CategoryBasedStoreSelectionPageArguments(
                    onCartItemChanged: (val) {},
                    onCartPressed: onCartPressed,
                    categoriesModel: category,
                  )
              );
            }
            else{
              onPressed(category);
            }
          },
          child: Material(
            elevation: 8,
            color: AppColors.BACK_WHITE_COLOR,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: CachedNetworkImage(
                    fadeInCurve: Curves.easeIn,
                    imageUrl: category.imageUrl != null ? category.imageUrl : "",
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/page_not_found_illustration.png",
                    ),
                    placeholder: (context, url) =>
                        SizedBox(
                          child: Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: Text(
                                'C',
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
                    width: 500,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 8,
                      ),
                      Text(category.name !=  null? category.name : "-",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ) : Container();
      }).toList() : [Container()],
    );
  }
}
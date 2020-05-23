import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/api/models/response/categoryResposeApi.dart';
import 'package:shimmer/shimmer.dart';

class RoundCategoryItem extends StatelessWidget {
  final CategoryResponseApi categoriesModel;
  final Function onClick;

  const RoundCategoryItem({Key key, @required this.categoriesModel, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoriesModel != null) {
      return Wrap(
        children: <Widget>[
          GestureDetector(
            onTap: onClick,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: categoriesModel.imageUrl != null ? categoriesModel.imageUrl : "",
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/page_not_found_illustration.png",
                        fit: BoxFit.scaleDown,
                        height: 90.0,
                        width: 90,
                      ),
                      placeholder: (context, url) => SizedBox(
                        height: 90.0,
                        width: 90,
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.grey,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                'C',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(height: 4,),
                  Container(
                    width: 90,
                      child: Text(
                    categoriesModel.name != null
                        ? categoriesModel.name
                        : "-",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ))
                ],
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}

import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListType1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ShimmerItem1(),
        ShimmerItem1(),
        ShimmerItem1(),
      ],
    );
  }
}


class ShimmerItem1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
        baseColor:AppColors.SHIMMER_DARK_COLOR,
        highlightColor: AppColors.SHIMMER_LIGHT_COLOR,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Row(
            children: <Widget>[
              Material(
                color: AppColors.BACK_WHITE_COLOR,
                child: Container(
                  height: 150,
                  width: 150,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              child: Container(
                                height: 20,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              child: Container(
                                height: 10,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              child: Container(
                                height: 5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
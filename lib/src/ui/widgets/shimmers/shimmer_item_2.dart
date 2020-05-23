
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

// location selector type
class ShimmerItem2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width - 40,
      child: Shimmer.fromColors(
        baseColor:AppColors.SHIMMER_DARK_COLOR,
        highlightColor: AppColors.SHIMMER_LIGHT_COLOR,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: <Widget>[
              Material(
                color: AppColors.BACK_WHITE_COLOR,
                child: Container(
                  height: 60,
                  width: 60,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              child: Container(
                                height: 8,
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
                                height: 8,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
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
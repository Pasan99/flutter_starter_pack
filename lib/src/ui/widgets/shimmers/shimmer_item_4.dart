
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

// search bar style
class ShimmerItem4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
                  height: 40,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
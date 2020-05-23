
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

// big image style
class ShimmerItem3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: MediaQuery.of(context).size.width - 80,
      child: Shimmer.fromColors(
        baseColor:AppColors.SHIMMER_DARK_COLOR,
        highlightColor: AppColors.SHIMMER_LIGHT_COLOR,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: Row(
            children: <Widget>[
              Material(
                color: AppColors.BACK_WHITE_COLOR,
                child: Container(
                  height: MediaQuery.of(context).size.width - 84,
                  width: MediaQuery.of(context).size.width - 84,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
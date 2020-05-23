import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListType2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ShimmerItem5(),
        ShimmerItem5(),
        ShimmerItem5(),
      ],
    );
  }
}


class ShimmerItem5 extends StatelessWidget {
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
              Expanded(
                child: Material(
                  color: AppColors.BACK_WHITE_COLOR,
                  child: Container(
                    height: 180,
                    width: 150,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(width: 16,),
              Expanded(
                child: Material(
                  color: AppColors.BACK_WHITE_COLOR,
                  child: Container(
                    height: 180,
                    width: 150,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
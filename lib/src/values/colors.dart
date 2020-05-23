import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors{
  static final Color MAIN_COLOR = HexColor("#1AD364");
  static final Color LIGHT_MAIN_COLOR = HexColor("#5AF297");
  static final Color WARNING_NOTIFY_COLOR = Colors.red;
  static final Color WARNING_NOTIFY_COLOR_LIGHT = Colors.red[400];
  static final Color BOTTOM_NAVIGATION_SELECTED_ICON_COLOR = HexColor("#8CC63E");
  static final Color BOTTOM_NAVIGATION_UNSELECTED_ICON_COLOR = Colors.grey[500];
  static final Color BACK_WHITE_COLOR = Colors.white;
  static final Color DIVIDER_COLOR = Colors.grey;


  static final Color TEXT_WHITE = Colors.white;
  static final Color TEXT_SUCCESS = Colors.green;
  static final Color DARK_TEXT_COLOR = Colors.black;
  static final Color LIGHT_TEXT_COLOR = Colors.grey;
  static final Color LIGHT_TEXT_COLOR_MIDDLE = Colors.grey[500];
  static final Color LIGHTER_TEXT_COLOR = Colors.grey[200];
  static final Color SHIMMER_DARK_COLOR = Colors.grey[300];
  static final Color SHIMMER_LIGHT_COLOR = Colors.white;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
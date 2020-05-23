import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';

class NavigationPageViewModel with ChangeNotifier{
  double cartItemCount = 0;

  NavigationPageViewModel(){
    getCartItems();
  }

  setCount(double count){
    cartItemCount = count;
    notifyListeners();
  }

  Future<bool> getCartItems() async {
    cartItemCount = (await CartHelper().getCartItemCount()).toDouble();
    notifyListeners();
    return true;
  }
}
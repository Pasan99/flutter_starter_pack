//import 'dart:convert';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:food_deliver/src/api/models/response/store_response_api.dart';
//import 'package:food_deliver/src/db/dao/cart_item_dao.dart';
//import 'package:food_deliver/src/db/dao/config_dao.dart';
//import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
//import 'package:food_deliver/src/db/entity/configurations_entity.dart';
//import 'package:food_deliver/src/db/entity/package_entity.dart';
//import 'package:food_deliver/src/utills/cart_total_calculator.dart';
//import 'package:food_deliver/src/utills/user_auth.dart';
//
//class PackageDetailsViewModel with ChangeNotifier {
//  PackageEntity package = PackageEntity();
//  String selectedShopId;
//  int itemsAddedToCart = 0;
//  List<CartItemEntity> cartItems;
//
//  double totalPrice;
//  double maxOrderCount = 0;
//  StoreResponseApi selectedStore;
//  int maxCashOrderAmount = 0;
//
//  PackageDetailsViewModel({@required PackageEntity package, @required this.selectedStore}){
//    setItems(package);
//  }
//
//  Future<void> setItems(PackageEntity package) async {
//    await _getMaxCashOrderAmount();
//    await _getTotal();
//    //_getMaxOrderCount();
//
//    this.package =  package;
//    await findItemsAddedToCart();
//    notifyListeners();
//  }
//
//  Future<bool> addToCart(PackageEntity selected, int amount) async {
//    if (selected.storeId == selectedShopId || selectedShopId == "") {
//
//      CartItemDAO dao = new CartItemDAO();
//      CartItemEntity cartItem = CartItemEntity();
//      cartItem.package = selected;
//      cartItem.userId = (await UserAuth().getCurrentUser()).authId;
//      cartItem.total = selected.packageAmount;
//
//      if (amount > 0) {
//        // update package count in cart
//        if (selected.isAddedToCart) {
//          print("Increase");
//          cartItem.quantity = amount;
//          cartItem.total = selected.packageAmount * cartItem.quantity;
//          bool success = await dao.updateData(
//              cartItem, where: "package = '${jsonEncode(selected.toMap())}'");
//          if (success) {
//            package.inCartCount = cartItem.quantity;
//          }
//        }
//        // adding package to cart
//        else {
//          package.isAddedToCart = true;
//          cartItem.quantity = 1;
//          cartItem.storeMaxOrderLimit = maxOrderCount;
//          dao.insertData(cartItem);
//        }
//      }
//      else{
//        // remove item
//        selected.isAddedToCart = false;
//        await removeItem(selected);
//      }
//
//      getCartItems();
//      await _getTotal();
//      notifyListeners();
//      return Future.value(true);
//    }
//    else{
//      return Future.value(false);
//    }
//  }
//
//  Future<void> removeItem(PackageEntity item) async {
//    package.isAddedToCart = false;
//
//    List<CartItemEntity> cartItems = await getCartItems();
//    int id;
//    CartItemEntity selected;
//    cartItems.forEach((cartItem){
//      if (cartItem.package.ID == item.ID){
//        id = cartItem.ID;
//        selected = cartItem;
//      }
//    });
//
//    // update db
//    CartItemDAO dao = CartItemDAO();
//    await dao.deleteData(selected, where: "ID = '$id'");
//  }
//
//  Future<void> findItemsAddedToCart() async {
//    selectedShopId = "";
//    List<CartItemEntity> cartItems = await getCartItems();
//
//    if (cartItems == null){
//      selectedShopId = "";
//    }
//    else{
//        cartItems.forEach((cartItem){
//          itemsAddedToCart += cartItem.quantity;
//          if (cartItem.package.ID == package.ID){
//            package.isAddedToCart = true;
//            package.inCartCount = cartItem.quantity;
//          }
//          selectedShopId = cartItem.package.storeId;
//        });
//    }
//  }
//
//  Future<List<CartItemEntity>> getCartItems() async {
//    CartItemDAO dao = CartItemDAO();
//    cartItems = List<CartItemEntity>();
//    cartItems = await dao.getMatchingEntries(CartItemEntity());
//    if (cartItems != null){
//      print(cartItems.toList().toString());
//      notifyListeners();
//      return Future.value(cartItems);
//    }
//    else{
//      return null;
//    }
//  }
//
//
//  int getCartItemCount()  {
//    if (cartItems != null) {
//      int count = 0;
//      cartItems.forEach((item){
//        count += item.quantity;
//      });
//      return count;
//    }
//    return 0;
//  }
//
//  _getMaxCashOrderAmount() async {
//    ConfigDAO configDAO = new ConfigDAO();
//    ConfigurationsEntity configurations = await configDAO.getMatchingEntry(ConfigurationsEntity());
//    maxCashOrderAmount = configurations.maxCashOrderAmount;
//  }
//
////  _getMaxOrderCount(){
////    maxOrderCount = selectedStore.maxDailyOrders.toDouble();
////  }
//
//  _getTotal() async {
//    List<CartItemEntity> items = await getCartItems();
//    if (items != null) {
//      totalPrice = await CartTotalCalculator(items: items).getTotal();
//    }
//    else totalPrice = 0;
//  }
//
//  bool isMaximumAmountReached(double amount){
//    print(totalPrice);
//    if (maxCashOrderAmount < totalPrice + amount){
//      return true;
//    }
//    else{
//      return false;
//    }
//  }
//
//  Future<bool> clearCart() async {
//    if (cartItems != null) {
//      cartItems.forEach((item) async {
//        await CartItemDAO().deleteData(
//            CartItemEntity(), where: "ID = '${item.ID}'");
//      });
//      bool isExist = await CartItemDAO().isExists(
//          CartItemEntity(), where: "ID = '${cartItems[0].ID}'");
//      if (isExist) {
//        return false;
//      }
//      selectedShopId = "";
//      _getTotal();
//      notifyListeners();
//      return true;
//    }
//    return false;
//  }
//
//
//}

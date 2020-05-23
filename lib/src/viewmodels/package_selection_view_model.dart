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
//class PackageSelectionViewModel with ChangeNotifier {
//  List<PackageEntity> items = List<PackageEntity>();
//  String selectedShopId;
//  int itemsAddedToCart = 0;
//  int maxCashOrderAmount = 0;
//  Function onCartPressed;
//  double totalPrice = 0;
//  double maxOrderCount = 0;
//  StoreResponseApi selectedStore;
//
//  PackageSelectionViewModel(List<PackageEntity> items, StoreResponseApi selectedStore){
//    this.selectedStore = selectedStore;
//    setItems(items);
//  }
//
//  Future<void> setItems(List<PackageEntity> items) async {
//    await _getMaxCashOrderAmount();
//    await _getTotal();
//    //_getMaxOrderCount();
//
//    print("Packages Count : ${items.length}");
//    this.items =  items;
//    print(this.runtimeType.toString());
//    print(items.length);
//    await findItemsAddedToCart();
//
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
//            items[items.indexOf(selected)].inCartCount = cartItem.quantity;
//          }
//          await _getTotal();
//        }
//        // adding package to cart
//        else {
//          items[items.indexOf(selected)].isAddedToCart = true;
//          cartItem.quantity = 1;
//          cartItem.storeMaxOrderLimit = maxOrderCount;
//          await dao.insertData(cartItem);
//          await _getTotal();
//        }
//      }
//      else{
//        // remove item
//        selected.isAddedToCart = false;
//        await removeItem(selected);
//        await _getTotal();
//      }
//      notifyListeners();
//      return Future.value(true);
//    }
//    else{
//      return Future.value(false);
//    }
//  }
//
//  Future<void> removeItem(PackageEntity item) async {
//    items[items.indexOf(item)].isAddedToCart = false;
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
//  Future<List<CartItemEntity>> getCartItems() async {
//    CartItemDAO dao = CartItemDAO();
//    List<CartItemEntity> cartItems = List<CartItemEntity>();
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
//  Future<void> findItemsAddedToCart() async {
//    selectedShopId = "";
//    List<CartItemEntity> cartItems = await getCartItems();
//
//    if (cartItems == null){
//      selectedShopId = "";
//    }
//    else{
//      items.forEach((package){
//        cartItems.forEach((cartItem){
//          itemsAddedToCart += cartItem.quantity;
//          if (cartItem.package.ID == package.ID){
//            package.isAddedToCart = true;
//            package.inCartCount = cartItem.quantity;
//          }
//          selectedShopId = cartItem.package.storeId;
//        });
//      });
//    }
//  }
//
//  int getCartItemCount(){
//    int count = 0;
//    if (items != null){
//      items.forEach((item){
//        if (item.isAddedToCart) {
//          count += item.inCartCount;
//        }
//      });
//    }
//    return count;
//  }
//
//  _getMaxCashOrderAmount() async {
//    ConfigDAO configDAO = new ConfigDAO();
//    ConfigurationsEntity configurations = await configDAO.getMatchingEntry(ConfigurationsEntity());
//    maxCashOrderAmount = configurations.maxCashOrderAmount;
//  }
//
//  _getMaxOrderCount(){
//      maxOrderCount = selectedStore.maxDailyOrders.toDouble();
//  }
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
//    List<CartItemEntity> items = await getCartItems();
//    items.forEach((item) async {
//      await CartItemDAO().deleteData(CartItemEntity(), where: "ID = '${item.ID}'");
//    });
//    bool isExist = await CartItemDAO().isExists(CartItemEntity(), where: "ID = '${items[0].ID}'");
//    if (isExist){
//      return false;
//    }
//    selectedShopId = "";
//    _getTotal();
//    return true;
//  }
//
//}

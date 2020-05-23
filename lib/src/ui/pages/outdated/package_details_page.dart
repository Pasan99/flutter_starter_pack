//import 'package:auto_route/auto_route.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:food_deliver/src/api/models/response/store_response_api.dart';
//import 'package:food_deliver/src/db/entity/package_entity.dart';
//import 'package:food_deliver/src/values/colors.dart';
//import 'package:food_deliver/src/viewmodels/package_details_view_model.dart';
//import 'package:provider/provider.dart';
//
//class PackageDetailsPage extends StatefulWidget {
//  final PackageEntity selectedPackage;
//  final StoreResponseApi selectedStore;
//  final Function onCartPressed;
//  final Function onCartItemChanged;
//  final Function onClearCart;
//  bool isShowAddToCart = true;
//
//  PackageDetailsPage(
//      {@required this.selectedPackage,
//      @required this.onCartPressed,
//      @required this.selectedStore,
//      @required this.onCartItemChanged,
//      this.isShowAddToCart, @required this.onClearCart});
//
//  @override
//  _PackageDetailsPageState createState() => _PackageDetailsPageState();
//}
//
//class _PackageDetailsPageState extends State<PackageDetailsPage> {
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider(
//      create: (context) => PackageDetailsViewModel(
//          package: widget.selectedPackage, selectedStore: widget.selectedStore),
//      child: Scaffold(
//        appBar: AppBar(
//          iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
//          title: Text(
//            widget.selectedPackage.packageName != null
//                ? widget.selectedPackage.packageName
//                : "",
//            style: TextStyle(color: AppColors.TEXT_WHITE),
//          ),
//          backgroundColor: AppColors.MAIN_COLOR,
//        ),
//        body: Column(
//          children: <Widget>[
//            Expanded(
//              flex: 2,
//              child: Padding(
//                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
//                child: ListView(
//                  children: widget.selectedPackage.items.map((packageItem) {
//                    return Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: Padding(
//                            child: Text(packageItem.productName != null
//                                ? packageItem.productName
//                                : ""),
//                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
//                          ),
//                        ),
//                        Expanded(
//                          child: Padding(
//                            child: Text(
//                              packageItem.qty != null ? packageItem.qty : "0",
//                              textAlign: TextAlign.end,
//                            ),
//                            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
//                          ),
//                        ),
//                      ],
//                    );
//                  }).toList(),
//                ),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Divider(
//                height: 2.0,
//                color: Colors.grey[500],
//              ),
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  flex: 2,
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(32, 0, 24, 16),
//                    child: Text(
//                      widget.selectedPackage.packageName != null
//                          ? widget.selectedPackage.packageName
//                          : "",
//                      style:
//                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  flex: 1,
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(32, 0, 24, 16),
//                    child: Text(
//                      'LKR${widget.selectedPackage.packageAmount != null ? widget.selectedPackage.packageAmount.toStringAsFixed(2) : ""}',
//                      textAlign: TextAlign.start,
//                      style: TextStyle(
//                          fontWeight: FontWeight.normal, fontSize: 14),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Visibility(
//              visible: widget.isShowAddToCart,
//              child: Expanded(
//                flex: 1,
//                child: Padding(
//                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
//                  child: Consumer<PackageDetailsViewModel>(
//                      builder: (context, model, child) {
//
///////////////////////  Changes Due to New Requirement /////////////////////////////////////////////////////////
//
//                        return Container();
////                    return Visibility(
////                      visible: widget.isShowAddToCart,
////                      child: widget.selectedPackage.inventoryCount > 0
////                          ? AddToCartButton(
////                              item: model.package,
////                              onChanged: (amount) async {
////                                if (model.selectedShopId != "" && model.package.storeId !=
////                                    model.selectedShopId) {
////                                  PopupDialogs.showSimpleErrorWithSinglePop(
////                                      context: context,
////                                      message:
////                                          "You already have items from a different store in your shopping cart",
////                                      btnIcon: Icon(Icons.remove_shopping_cart),
////                                      btnName: "Clear Cart",
////                                      title: "Notice",
////                                      onClick: (context) async {
////                                        bool isSuccess =
////                                            await model.clearCart();
////                                        if (isSuccess) {
////                                          widget.onCartItemChanged();
////                                          widget.onClearCart();
////                                        }
////                                        Navigator.of(context).pop();
////                                      });
////                                  return;
////                                }
////                                if (!model.isMaximumAmountReached(
////                                    model.package.packageAmount)) {
////                                  bool success = await model.addToCart(
////                                      model.package, amount);
////                                  if (success) {
////                                    widget.onCartItemChanged();
////                                  }
////                                }
////
////                                // exceeded the transaction limit configuration
////                                else {
////                                  PopupDialogs.showSimplePopDialog(
////                                      context,
////                                      "Cart is full",
////                                      "You reached the maximum transaction limit of LKR ${model.maxCashOrderAmount.toStringAsFixed(2)}");
////                                }
////                              },
////                              onRemoveFromCart: () {},
////                            )
////                          : Padding(
////                              padding: const EdgeInsets.all(8.0),
////                              child: Row(
////                                mainAxisAlignment: MainAxisAlignment.center,
////                                children: <Widget>[
////                                  Icon(
////                                    Icons.store,
////                                    color: AppColors.WARNING_NOTIFY_COLOR,
////                                  ),
////                                  Padding(
////                                    padding: const EdgeInsets.symmetric(
////                                        horizontal: 12),
////                                    child: Text(
////                                      "Out of Stock",
////                                      style: TextStyle(
////                                          color:
////                                              AppColors.WARNING_NOTIFY_COLOR),
////                                    ),
////                                  ),
////                                ],
////                              ),
////                            ),
////                    );
//                  }),
//                ),
//              ),
//            ),
//            Visibility(
//              visible: widget.isShowAddToCart,
//              child: Container(
//                color: AppColors.MAIN_COLOR,
//                child: Consumer<PackageDetailsViewModel>(
//                    builder: (context, model, child) {
//                  if (model.getCartItemCount() != 0) {
//                    return SafeArea(
//                      child: Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: Padding(
//                              padding: const EdgeInsets.symmetric(
//                                  horizontal: 16, vertical: 4),
//                              child: Text(
//                                model.getCartItemCount().toString() +
//                                    " items LKR ${model.totalPrice != null ? model.totalPrice.toStringAsFixed(2) : ''} ",
//                                style: TextStyle(color: AppColors.TEXT_WHITE),
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.symmetric(
//                                horizontal: 16, vertical: 4),
//                            child: Visibility(
//                              child: OutlineButton(
//                                onPressed: () {
//                                  ExtendedNavigator.of(context).pop();
//                                  widget.onCartPressed();
//                                },
//                                child: Text(
//                                  "VIEW CART",
//                                  style: TextStyle(color: AppColors.TEXT_WHITE),
//                                ),
//                              ),
//                              visible: widget.isShowAddToCart,
//                            ),
//                          )
//                        ],
//                      ),
//                    );
//                  }
//                  return Container();
//                }),
//              ),
//            )
//            //PriceAlertBox(),
//          ],
//        ),
////          floatingActionButton: Consumer<PackageDetailsViewModel>(
////              builder: (context, model, child) {
////            if (model.getCartItemCount() != 0) {
////              return FloatingActionButton.extended(
////                backgroundColor: AppColors.MAIN_COLOR,
////                label: Text(model.getCartItemCount().toString(),
////                    style: TextStyle(fontSize: 18)),
////                onPressed: () {
////                  ExtendedNavigator.of(context).pop();
////                  widget.onCartPressed();
////                },
////                icon: Image.asset(
////                  "assets/images/ic_nav_cart.png",
////                  height: 20,
////                ),
////              );
////            } else {
////              return FloatingActionButton(
////                child: Image.asset(
////                  "assets/images/ic_nav_cart.png",
////                  height: 20,
////                ),
////                backgroundColor: AppColors.MAIN_COLOR,
////                onPressed: () {
////                  ExtendedNavigator.of(context).pop();
////                  widget.onCartPressed();
////                },
////              );
////            }
////          })
//      ),
//    );
//  }
//}

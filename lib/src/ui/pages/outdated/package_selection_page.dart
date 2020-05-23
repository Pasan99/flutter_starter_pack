//import 'package:auto_route/auto_route.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:food_deliver/src/api/models/response/store_response_api.dart';
//import 'package:food_deliver/src/db/entity/package_entity.dart';
//import 'package:food_deliver/src/routes/router.gr.dart';
//import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
//import 'package:food_deliver/src/ui/package_item_widget.dart';
//import 'package:food_deliver/src/values/colors.dart';
//import 'package:food_deliver/src/viewmodels/package_selection_view_model.dart';
//import 'package:provider/provider.dart';
//import 'package:easy_localization/easy_localization.dart';
//import 'package:shimmer/shimmer.dart';
//
//class PackageSelectionPage extends StatefulWidget {
//  final List<PackageEntity> packages;
//  final StoreResponseApi selectedStore;
//  final Function onCartPressed;
//  final Function onCartItemChanged;
//  final Function onClearCart;
//  final String imageUrl;
//
//  PackageSelectionPage(
//      {@required this.packages,
//      @required this.selectedStore,
//      @required this.onCartPressed,
//      @required this.onCartItemChanged,
//        this.onClearCart, @required this.imageUrl});
//
//  @override
//  _PackageSelectionPageState createState() => _PackageSelectionPageState();
//}
//
//class _PackageSelectionPageState extends State<PackageSelectionPage> {
//  bool isHidden = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider(
//      create: (context) =>
//          PackageSelectionViewModel(widget.packages, widget.selectedStore),
//      child: Scaffold(
//        body: NestedScrollView(
//          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//            return <Widget>[
//              SliverAppBar(
//                expandedHeight: 250.0,
//                floating: false,
//                pinned: true,
//                iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
//                backgroundColor: AppColors.MAIN_COLOR,
//                flexibleSpace: FlexibleSpaceBar(
//                    title: Text(
//                        'select_a_pakage',
//                        textAlign: TextAlign.left,
//                        style: TextStyle(
//                          color: AppColors.TEXT_WHITE,
//                          fontSize: 16.0,
//                        )).tr(),
//                    background: CachedNetworkImage(
//                      imageUrl: widget.imageUrl,
//                      placeholder: (context, url) =>
//                          SizedBox(
//                            height: 150.0,
//                            child: Shimmer.fromColors(
//                              baseColor: Colors.black12,
//                              highlightColor: Colors.grey,
//                              child: Padding(
//                                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
//                                child: Text(
//                                  'FairSpace',
//                                  textAlign: TextAlign.center,
//                                  style: TextStyle(
//                                    fontSize: 40.0,
//                                    fontWeight:
//                                    FontWeight.bold,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                      height: 150,
//                      width: 500,
//                      fit: BoxFit.cover,
//                    )),
//              ),
//            ];
//          },
//          body: Column(
//            children: <Widget>[
////              Consumer<PackageSelectionViewModel>(
////                  builder: (context, model, child) {
////                return BannerAlertBox(
////                  amount: model.maxCashOrderAmount != null
////                      ? model.maxCashOrderAmount.toStringAsFixed(2)
////                      : 0,
////                  name: widget.selectedStore.storeName != null
////                      ? widget.selectedStore.storeName
////                      : "",
////                );
////              }),
//              Expanded(
//                child: Consumer<PackageSelectionViewModel>(
//                    builder: (context, model, child) {
//                  if ( model.items != null && model.items.length > 0) {
//                    return ListView(
//                      children: model.items.map((package) {
//                        print(package.isAddedToCart);
//                        return PackageItemWidget(
//                          item: package,
//                          onClick: () {
//                            ExtendedNavigator.of(context)
//                                .pushNamed(Routes.packageDetailsPage,
//                                    arguments: PackageDetailsPageArguments(
//                                      onClearCart: widget.onClearCart,
//                                        onCartItemChanged: () {
//                                          widget.onCartItemChanged(
//                                              model.getCartItemCount());
//                                        },
//                                        selectedPackage: package,
//                                        onCartPressed: () {
//                                          ExtendedNavigator.of(context).pop();
//                                          widget.onCartPressed();
//                                        },
//                                        isShowAddToCart: true,
//                                        selectedStore: widget.selectedStore));
//                          },
//                          onItemCountChanged: (amount) async {
//                            // max order count reached
//                            print("I am Calling");
//                            if (model.selectedShopId != "" && package.storeId != model.selectedShopId) {
//                              PopupDialogs.showSimpleErrorWithSinglePop(
//                                  context: context,
//                                  message:
//                                      "You already have items from a different store in your shopping cart",
//                                  btnIcon: Icon(Icons.remove_shopping_cart),
//                                  btnName: "Clear Cart",
//                                  title: "Notice",
//                                  onClick: (context) async {
//                                    bool isSuccess = await model.clearCart();
//                                    if (isSuccess) {
//                                      widget.onCartItemChanged(0);
//                                      widget.onClearCart();
//                                    }
//                                    Navigator.of(context).pop();
//                                  });
//                              return;
//                            }
//                            if (!model.isMaximumAmountReached(
//                                    package.packageAmount) ||
//                                package.inCartCount > amount) {
//                              bool success =
//                                  await model.addToCart(package, amount);
//                              if (success) {
//                                widget
//                                    .onCartItemChanged(model.getCartItemCount());
//                              }
//                            }
//
//                            // exceeded the transaction limit configuration
//                            else {
//                              PopupDialogs.showSimplePopDialog(context, "Notice",
//                                  "You reached the maximum transaction limit of LKR ${model.maxCashOrderAmount.toStringAsFixed(2)}");
//                            }
//                          },
//                          onGoToCart: () {},
//                        );
//                      }).toList(),
//                    );
//                  }
//                  return Text('loading').tr();
//                }),
//              ),
//              Container(
//                color: AppColors.MAIN_COLOR,
//                child: Consumer<PackageSelectionViewModel>(
//                    builder: (context, model, child) {
//                  if (model.getCartItemCount() != 0) {
//                    return SafeArea(
//                      child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Expanded(
//                            child: Padding(
//                              padding: const EdgeInsets.symmetric(
//                                  horizontal: 16, vertical: 4),
//                              child: Text(
//                                model.getCartItemCount().toString() +
//                                    " items " +
//                                    "LKR " +
//                                    model.totalPrice.toStringAsFixed(2),
//                                style: TextStyle(color: AppColors.TEXT_WHITE),
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.symmetric(
//                                horizontal: 16, vertical: 4),
//                            child: OutlineButton(
//                              onPressed: () {
//                                ExtendedNavigator.of(context).pop();
//                                widget.onCartPressed();
//                              },
//                              child: Text(
//                                "VIEW CART",
//                                style: TextStyle(color: AppColors.TEXT_WHITE),
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    );
//                  }
//                  return Container();
//                }),
//              )
//            ],
//          ),
//        ),
////        floatingActionButton: Consumer<PackageSelectionViewModel>(
////            builder: (context, model, child) {
////          if (model.getCartItemCount() != 0) {
////            return FloatingActionButton.extended(
////              backgroundColor: AppColors.MAIN_COLOR,
////              label: Text(model.getCartItemCount().toString(),
////                  style: TextStyle(fontSize: 18)),
////              onPressed: () {
////                ExtendedNavigator.of(context).pop();
////                widget.onCartPressed();
////              },
////              icon: Image.asset(
////                "assets/images/ic_nav_cart.png",
////                height: 20,
////              ),
////            );
////          } else {
////            return FloatingActionButton(
////              child: Image.asset(
////                "assets/images/ic_nav_cart.png",
////                height: 20,
////              ),
////              backgroundColor: AppColors.MAIN_COLOR,
////              onPressed: () {
////                ExtendedNavigator.of(context).pop();
////                widget.onCartPressed();
////              },
////            );
////          }
////        }),
//      ),
//    );
//  }
//}
//
//class BannerAlertBox extends StatefulWidget {
//  final amount;
//  final name;
//
//  const BannerAlertBox({Key key, @required this.amount, @required this.name})
//      : super(key: key);
//
//  @override
//  _BannerAlertBoxState createState() => _BannerAlertBoxState();
//}
//
//class _BannerAlertBoxState extends State<BannerAlertBox> {
//  bool isHidden = false;
//
//  @override
//  Widget build(BuildContext context) {
//    if (!isHidden) {
//      return Container(
//        color: AppColors.LIGHTER_TEXT_COLOR,
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: Container(
//                    child: Padding(
//                      padding: const EdgeInsets.fromLTRB(32.0, 24, 32, 0),
//                      child: Center(
//                          child: Text(
//                        '${widget.name} ' +
//                            'only_allow_you_to_have_maximum_of'.tr() +
//                            ' ${widget.amount}',
//                        style: TextStyle(
//                            fontWeight: FontWeight.w500, fontSize: 16),
//                      )),
//                    ),
//                  ),
//                )
//              ],
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(8.0, 4, 40, 12),
//                  child: OutlineButton(
//                    splashColor: AppColors.MAIN_COLOR,
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(24)),
//                    onPressed: () {
//                      setState(() {
//                        isHidden = true;
//                      });
//                    },
//                    child: Text('hide').tr(),
//                  ),
//                )
//              ],
//            )
//          ],
//        ),
//      );
//    } else {
//      return Container();
//    }
//  }
//}

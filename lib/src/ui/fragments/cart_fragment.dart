import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/ui/widgets/cart_item.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/cart_view_model.dart';
import 'package:provider/provider.dart';

import '../../routes/router.gr.dart';

class CartFragment extends StatefulWidget {
  final Function onCartItemChanged;
  final Function onOrderPlaced;

  const CartFragment({Key key, this.onCartItemChanged, this.onOrderPlaced}) : super(key: key);

  @override
  _CartFragmentState createState() => _CartFragmentState();
}

class _CartFragmentState extends State<CartFragment> {
  List<CartItemEntity> items = List<CartItemEntity>();

  bool isFirstTime = true;
  bool isDisabled = false;

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<CartViewModel>(builder: (context, model, child) {
            return Text(
              "Cart" +
                  (model.items != null && model.items.length > 0
                      ? " (${model.items.length})"
                      : ""),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.DARK_TEXT_COLOR),
            );
          }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Consumer<CartViewModel>(builder: (context, model, child) {
                return GestureDetector(
                  onTap: () {
                    PopupDialogs.showSimpleErrorWithSinglePop(
                        context: context,
                        title: "Clear Cart",
                        message: "Are you sure you want to remove the items?",
                        btnName: "Yes",
                        btnIcon: Icon(
                          Icons.remove_circle_outline,
                          color: AppColors.WARNING_NOTIFY_COLOR_LIGHT,
                        ),
                        onClick: (context1) async {
                          await model.clearCart();
                          Navigator.of(context1).pop();
                        });
                  },
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                            model.items != null && model.items.length > 0 ? "Clear Cart" : "",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppColors.DARK_TEXT_COLOR),
                        ),
                      ),
                      model.items != null && model.items.length > 0 ? Icon(Icons.delete) : Container(),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
        body: Container(
          color: AppColors.BACK_WHITE_COLOR,
          child: Column(
            children: <Widget>[
              Expanded(
                child:
                    Consumer<CartViewModel>(builder: (context, model, child) {
                  // cart is empty
                  if (model.items.isInvalid() && !isFirstTime) {
                    isFirstTime = false;
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(60.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SafeArea(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Image.asset(
                                    "assets/images/empty_cart_illustration.png",
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 16, 0, 10),
                                child: Center(
                                    child: Text(
                                  "Your cart is Empty",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  // items in the cart
                  else if (model.items.length > 0) {
                    return CupertinoScrollbar(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ListView(
                            controller: _scrollController,
                            children: model.items.map((item) {
                              return CartItem(
                                item: item,
                                onCartItemChangedFromDetails: () {
                                  model.getItems();
                                },
                                onCartPressed: () {
                                  model.getItems();
                                },
                                onQuantityChanged: (value) {
                                  // add quantity
                                  if (item.quantity < value) {
                                    if (!model.isMaximumAmountReached(
                                        item.product.productAmount)) {
                                      // update quantity
                                      model.onQuantityChanged(value, item);

                                      // update cart badge count
                                      double qnt = 0;
                                      model.items.forEach((item) {
                                        qnt += item.quantity;
                                      });
                                      widget.onCartItemChanged(qnt);
                                    } else {
                                      // reached maximum cash amount
                                      // disable button for delay
                                      if (!isDisabled) {
                                        PopupDialogs.showSimplePopDialog(
                                            context,
                                            "Cart is full",
                                            "You reached the maximum transaction limit of LKR ${model.maxCashOrderAmount.toStringAsFixed(2)}");
                                        isDisabled = true;
                                      }
                                      Future.delayed(
                                          const Duration(milliseconds: 4000),
                                          () {
                                        isDisabled = false;
                                      });
                                    }
                                  }
                                  // remove quantity
                                  else {
                                    model.onQuantityChanged(value, item);

                                    // update cart badge count
                                    double qnt = 0;
                                    model.items.forEach((item) {
                                      qnt += item.quantity;
                                    });
                                    widget.onCartItemChanged(qnt);
                                  }
                                },
                                onRemove: () {
                                  widget.onCartItemChanged(0.0);
                                  return model.removeItem(item);
                                },
                              );
                            }).toList()),
                      ),
                    );
                  }
                  // cart is loading
                  isFirstTime = false;
                  return Center(
                    child: SpinKitPulse(
                      color: AppColors.MAIN_COLOR,
                      size: 60.0,
                    ),
                  );
                }),
              ),
              Consumer<CartViewModel>(
                builder: (context, model, child) {
                  return model.items != null && model.items.length > 0 ?  Material(
                    elevation: 20,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.grey[100],
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 24, 24, 0),
                                    child: Text(
                                      "cart_subtotal",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                                  child: Consumer<CartViewModel>(
                                      builder: (context, model, child) {
                                    return Text(
                                      'LKR  ' + model.subTotal.toStringAsFixed(2),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    );
                                  }),
                                ),
                                // other fee
                              ],
                            ),
                            Consumer<CartViewModel>(
                                builder: (context, model, child) {
                              return Column(
                                children: model.fees.map((fee) {
                                  return Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              24, 8, 24, 0),
                                          child: Text(
                                            fee.name != null ? fee.name : "-",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.fromLTRB(24, 8, 24, 0),
                                        child: Consumer<CartViewModel>(
                                            builder: (context, model, child) {
                                          return Text(
                                            fee.finalAmount != null
                                                ? ('LKR  ' +
                                                    fee.finalAmount
                                                        .toStringAsFixed(2))
                                                : "-",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14),
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Divider(
                                height: 2,
                                color: AppColors.DIVIDER_COLOR,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 0, 24, 16),
                                    child: Text(
                                      "total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ).tr(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 24, 16),
                                    child: Consumer<CartViewModel>(
                                        builder: (context, model, child) {
                                      return Text(
                                        'LKR  ' +
                                            model.totalPrice.toStringAsFixed(2),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(24, 8, 24, 16),
                                    child: Consumer<CartViewModel>(
                                        builder: (context, model, child) {
                                      return WillPopScope(
                                        onWillPop: () {
                                          print("back pressed");
                                          return Future.value(isDisabled);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 12),
                                          child: CupertinoButton(
                                            color: AppColors.MAIN_COLOR,
                                            onPressed: () async {
                                              _goToCheckout(context, model);
                                            },
                                            child: Text(
                                              'checkout',
                                              style: TextStyle(
                                                  color: AppColors.TEXT_WHITE,
                                                  fontWeight: FontWeight.w400),
                                            ).tr(),
//                                    shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(8.0),
//                                    ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ) : Container();
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _goToCheckout(BuildContext context, CartViewModel model) async {
    if (model.items == null || model.items.length < 1) {
      if (!isDisabled) {
        PopupDialogs.showSimplePopDialog(
            context, "Empty Cart", "Please Add some Items to your cart");
        isDisabled = true;
      }
      Future.delayed(const Duration(milliseconds: 3000), () {
        isDisabled = false;
      });
    } else {
      PopupDialogs.showLoadingDialog(context, "please_wait".tr());
      // check order validation
      if (await model.isOrderValidated(context)) {
        ExtendedNavigator.of(context).pop();
        PopupDialogs.isShowingLodingDialog = false;
        ExtendedNavigator.of(context).pushNamed(Routes.checkoutPage,
            arguments: CheckoutPageArguments(
                onOrderPlaced: () async {
                  await model.getItems();
                  widget.onCartItemChanged(0);
                  widget.onOrderPlaced();
                },
                items: model.items,
                validatedOrder: model.validatedOrder,
                paymentValues: model.getFinalPayment()));
        return true;
      } else {
        if (model.currentResponse != Responses.NETWORK_DISCONNECTED &&
            model.currentResponse == Responses.ERROR) {
          PopupDialogs.showSimpleErrorWithDoublePop(
              context: context,
              title: "Error",
              message: model.validatedOrder.errorBody.message,
              btnName: "Update Cart",
              btnIcon: Icon(Icons.update),
              onClick: (context1) async {
                // package count error
                if (model.validatedOrder.errorBody.products != null) {
                  model.validatedOrder.errorBody.products
                      .forEach((product) async {
                    if (product.stock != null) {
                      await model.updateNewQuantity(product.Id, product.stock);
                    }
                    if (product.amount != null) {
                      await model.updateNewPrice(product.Id, product.amount);
                    }
                  });
                  await model.makeChanges();

                  // UI Notify
                  Scaffold.of(context).showSnackBar(SnackBar(
                    key: GlobalKey(debugLabel: "Error Snack Bar"),
                    content: Text(
                        "${model.validatedOrder.errorBody.products.length == 1 ? " 1 item has changed" : "${model.validatedOrder.errorBody.products.length} items have changed"} "),
                    behavior: SnackBarBehavior.floating,
                    elevation: 10,
                    duration: Duration(seconds: 2),
                  ));
                  _scrollController.animateTo(
                      model.items.length * 400.toDouble(),
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    model.items.forEach((item) {
                      if (item.isChanged) {
                        item.isChanged = false;
                      }
                      _scrollController.animateTo(
                          _scrollController.initialScrollOffset,
                          duration:
                              Duration(milliseconds: model.items.length * 300),
                          curve: Curves.easeIn);
                    });
                    setState(() {});
                  });

                  // Used for show item cart count in bottom navigation
                  widget.onCartItemChanged(model.items.length);
                } else {
                  print(model.validatedOrder.errorBody.products);
                }
                if (model.validatedOrder.errorBody.fees != null) {
                  await model.updateFees(context);
                }
                Navigator.of(context1).pop();
                Navigator.of(context1).pop();
                PopupDialogs.isShowingLodingDialog = false;
                return true;
              });
        } else {
          PopupDialogs.isShowingLodingDialog = true;
          PopupDialogs.showSimplePopDialog(
              context, "Error", "Something went wrong. Please try again");
        }
      }
    }
    return false;
  }
}

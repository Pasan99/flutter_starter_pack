import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_deliver/src/api/models/response/checkout_transaction_response.dart';
import 'package:food_deliver/src/api/models/response/validate_order_response.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/db/entity/payment_methods_entity.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/viewmodels/checkout_view_model.dart';
import 'package:provider/provider.dart';
import '../../routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItemEntity> items;
  final Map<FeesEntity, double> paymentValues;
  final Function onOrderPlaced;
  final CheckoutTransactionResponseApi validatedOrder;

  CheckoutPage(
      {@required this.items,
      @required this.paymentValues,
      @required this.validatedOrder,
      this.onOrderPlaced});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
        title: Text(
          'checkout',
          style: TextStyle(color: AppColors.TEXT_WHITE),
        ).tr(),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 0,
      ),
      body: CheckoutPageBody(
        validatedOrder: widget.validatedOrder,
        items: widget.items,
        paymentValues: widget.paymentValues,
        onOrderPlaced: widget.onOrderPlaced,
      ),
    );
  }
}

// ignore: camel_case_types
class CheckoutPageBody extends StatefulWidget {
  final List<CartItemEntity> items;
  final Map<FeesEntity, double> paymentValues;
  final CheckoutTransactionResponseApi validatedOrder;
  List<PaymentMethodEntity> paymentMethods;
  PaymentMethodEntity selectedPaymentMethod;
  final Function onOrderPlaced;
  bool _isFirstTime = true;

  TextEditingController note;
  bool isCreating = false;

  CheckoutPageBody(
      {@required this.items,
      @required this.paymentValues,
      @required this.validatedOrder,
      this.onOrderPlaced}) {
    paymentMethods =
        PaymentMethodEntity().convertToPaymentMethod(validatedOrder);
    if (paymentMethods != null && paymentMethods.isNotEmpty) {
      selectedPaymentMethod = paymentMethods[0];
    }
  }

  @override
  _CheckoutPageBodyState createState() => _CheckoutPageBodyState();
}

// ignore: camel_case_types
class _CheckoutPageBodyState extends State<CheckoutPageBody> {
  List<Widget> getPaymentValues() {
    int length = widget.paymentValues.length;
    List<double> values = widget.paymentValues.values.toList();
    List<FeesEntity> keys = widget.paymentValues.keys.toList();
    List<Widget> widgets = List();

    for (int i = 0; i < length; i++) {
      if (i < length - 1) {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(keys[i].name != null ? keys[i].name : "-")),
              Text("${values[i].toStringAsFixed(2)}"),
            ],
          ),
        ));
      } else {
        widgets.add(Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
              child: Divider(
                height: 1,
                color: AppColors.LIGHT_TEXT_COLOR,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  keys[i].name != null ? keys[i].name : "-",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
                Text("LKR ${values[i].toStringAsFixed(2)}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CheckoutViewModel(widget.items, widget.paymentValues, widget.validatedOrder),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 24, 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'order_items',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.DARK_TEXT_COLOR),
                                textAlign: TextAlign.start,
                              ).tr(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Material(
                          elevation: 5,
                          color: AppColors.BACK_WHITE_COLOR,
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 20, 28, 8),
                                child: Column(
                                  children: widget.items.map((cartItem) {
                                    return Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text("⬤  " +
                                                (cartItem.product.productName !=
                                                        null
                                                    ? cartItem
                                                        .product.productName
                                                    : "-") +
                                                (cartItem.quantity != null
                                                    ? "  (x${cartItem.quantity})"
                                                    : ""))),
                                        Text(cartItem.product.productAmount !=
                                                null
                                            ? "LKR ${cartItem.product.productAmount.toStringAsFixed(2)}"
                                            : "-"),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          28, 8, 28, 8),
                                      child: Divider(
                                        color: AppColors.LIGHT_TEXT_COLOR,
                                        height: 1,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(28, 8, 28, 8),
                                child: Column(
                                  children: getPaymentValues(),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 26, 8, 0),
                                      child: Divider(
                                        color: AppColors.LIGHT_TEXT_COLOR,
                                        height: 1,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 20, 24, 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'payment_method',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.DARK_TEXT_COLOR),
                                textAlign: TextAlign.start,
                              ).tr(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: PaymentSelector(
                          paymentMethods: widget.paymentMethods,
                          onSelectionChanged: (name) {
                            widget.selectedPaymentMethod = name;
                          },
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16,16, 0, 0),
                              child: Text(
                                'delivery_address_checkout',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.DARK_TEXT_COLOR),
                              ).tr(),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Container(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(16.0),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Consumer<CheckoutViewModel>(
                                    builder: (context, model, child) {
                                  if (model.selectedContact != null) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 12, 0),
                                              child: Icon(CupertinoIcons.home),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Container(
                                                height: 30,
                                                width: 1,
                                                color: AppColors.DIVIDER_COLOR,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                child: Text(
                                                  "${model.selectedContact.houseNo != null ? model.selectedContact.houseNo + "," : ""} "
                                                  "${model.selectedContact.street != null ? model.selectedContact.street : ""} ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 2, 6, 0),
                                              ),
                                            ),
                                          ],
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: Divider(
                                            height: 1,
                                            color: AppColors.DIVIDER_COLOR,
                                          ),
                                        ),
                                        Row(children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                                child: Text(
                                                  'estimate_delivery',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w300,
                                                      color: AppColors.DARK_TEXT_COLOR),
                                                ).tr()),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
                                              child: Text(
//                                                widget.validatedOrder.deliveryDate != null
//                                                    ? (widget.validatedOrder.deliveryDate.length >
//                                                    15 &&
//                                                    widget.validatedOrder.deliveryDate
//                                                        .contains("Z")
//                                                    ? widget.validatedOrder.deliveryDate
//                                                    .substring(0, 10)
//                                                    : widget.validatedOrder.deliveryDate)
//                                                    : "-",
                                              "",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.DARK_TEXT_COLOR),
                                              ))
                                        ]),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                    'checkout_note',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight: FontWeight.w300,
                                                        color: AppColors.LIGHT_TEXT_COLOR),
                                                  ).tr())
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                              ),
                            ),
                          ))),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 24, 8, 24),
                                child: Consumer<CheckoutViewModel>(
                                    builder: (context, model, child) {
                                  return TextField(
                                    controller: model.noteEditor,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      hintText:
                                          "Note: e.g. bring change for Rs. 500.00",
                                      border: OutlineInputBorder(),
                                    ),
                                  );
//                                      CupertinoTextField(
//                                       //BoxDecoration : new InputDecoration( filled: true,fillColor:Colors.white),
//                                      controller: model.noteEditor,
//
//                                      placeholder:
//                                          "Note: e.g. bring change for Rs. 500.00",
//                                      padding: EdgeInsets.all(12),
//                                    );
                                })),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.LIGHTER_TEXT_COLOR,
              child: Material(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 5, 12, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      'total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ).tr())
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                      child: Text(
                                        "LKR ${widget.paymentValues.values.toList()[widget.paymentValues.values.toList().length - 1].toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: ButtonTheme(
                          height: 50,
                          child: Consumer<CheckoutViewModel>(
                              builder: (context, model, child) {
                            return RaisedButton(
                              color: AppColors.MAIN_COLOR,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              onPressed: () async {
                                if (widget._isFirstTime) {
                                  widget._isFirstTime = false;
                                  PopupDialogs.showLoadingDialog(
                                      context, "please_wait".tr());
                                  if (await _createOrder(
                                      model,
                                      widget.selectedPaymentMethod != null
                                          ? widget.selectedPaymentMethod.ID
                                          : "null",
                                      model.noteEditor.text.toString())) {
                                    await model.clearCart();
                                    widget.onOrderPlaced();
                                    if (model.resultOrder != null && model.resultOrder.items != null && model.resultOrder.storeName!= null) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      PopupDialogs.isShowingLodingDialog = false;
                                      ExtendedNavigator.of(context).pushNamed(
                                          Routes.myOrderShopDetailPage,
                                          arguments:
                                          MyOrderShopDetailPageArguments(
                                              order: model.resultOrder,
                                              language: model
                                                  .currentUser.language));
                                    }
                                    else{
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      PopupDialogs.isShowingLodingDialog = false;
                                      ExtendedNavigator.of(context).pushNamed(Routes.orderSubmittedPage);
                                    }
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              child: Text(
                                'place_order',
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.normal, color: AppColors.TEXT_WHITE),
                              ).tr(),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _createOrder(
      CheckoutViewModel model, String paymentMethod, String note) async {
    bool isSuccess =
        await model.addOrder(context, paymentMethod: paymentMethod, note: note);
    if (isSuccess) {
      return true;
    } else {
      if (model.currentResponse != Responses.NETWORK_DISCONNECTED) {
        PopupDialogs.isShowingLodingDialog = true;
        Navigator.pop(context);
        if (model.resultOrder != null && model.resultOrder.errorBody != null) {
          String message = await LanguageHelper(names: model.resultOrder.errorBody.messages).getName();
          PopupDialogs.showSimplePopDialog(
              context, "Error", message);
        }
      } else {
        PopupDialogs.isShowingLodingDialog = true;
        Navigator.pop(context);
        PopupDialogs.showSimplePopDialog(
            context, "Error", "Something went wrong. Please try again");
      }
      widget._isFirstTime = true;
      return false;
    }
  }
}

// ignore: must_be_immutable
class PaymentSelector extends StatefulWidget {
  final List<PaymentMethodEntity> paymentMethods;
  final Function onSelectionChanged;
  PaymentMethodEntity selected;

  PaymentSelector({@required this.paymentMethods, this.onSelectionChanged}) {
    if (paymentMethods != null && paymentMethods.length > 0) {
      selected = paymentMethods[0];
    }
  }

  @override
  _PaymentSelectorState createState() => _PaymentSelectorState();
}

class _PaymentSelectorState extends State<PaymentSelector> {
  @override
  Widget build(BuildContext context) {
    if (widget.paymentMethods != null && widget.paymentMethods.length > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.paymentMethods.map((method) {
          return CustomButton(
            name: method.name,
            onSelected: () {
              setState(() {
                widget.selected = method;
                return widget.onSelectionChanged(widget.selected);
              });
            },
            isSelected: widget.selected == method,
          );
        }).toList(),
      );
    } else {
      return Container(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('no_payment_methods_available').tr()),
        ),
      );
    }
  }
}

class CustomButton extends StatefulWidget {
  final Function onSelected;
  final String name;
  final isSelected;

  const CustomButton(
      {this.onSelected, @required this.name, @required this.isSelected});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      return Expanded(
        child: Container(
            width: 150,
            height: 140,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 12, 15, 24),
              child: RaisedButton(
                color: AppColors.LIGHT_MAIN_COLOR,
                onPressed: widget.onSelected,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.DARK_TEXT_COLOR),
                  ).tr(),
                ),
              ),
            )),
      );
    } else {
      return Expanded(
        child: Container(
            width: 150,
            height: 140,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 12, 15, 24),
              child: OutlineButton(
                onPressed: widget.onSelected,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    widget.name != null ? widget.name : "No Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.DARK_TEXT_COLOR),
                  ).tr(),
                ),
              ),
            )),
      );
    }
  }
}

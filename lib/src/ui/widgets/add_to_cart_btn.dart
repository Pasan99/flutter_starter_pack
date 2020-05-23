import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/ui/widgets/counter_widget.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/values/colors.dart';

class AddToCartButton extends StatefulWidget {
  final ProductEntity item;
  final String symbol;
  final Function onChanged;
  final Function onRemoveFromCart;
  final List<double> customSteps;
  final int maxValue;
  bool isScaled = false;

  AddToCartButton(
      {this.item,
      this.onChanged,
      this.onRemoveFromCart,
      this.symbol,
        this.isScaled = false,
      this.customSteps,
      this.maxValue});

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  @override
  Widget build(BuildContext context) {
    if (widget.item.isAddedToCart) {
      return Row(
        children: <Widget>[
          Container(
            child: Counter(
              symbol: widget.symbol != null
                  ? (widget.symbol.length > 4
                      ? widget.symbol.substring(0, 3)
                      : widget.symbol)
                  : "",
              initialValue: widget.item.inCartCount,
              minValue: 0,
              isScaled: widget.isScaled,
              maxValue: widget.maxValue != null ? widget.maxValue : 1000,
              step: 1,
              productEntity: widget.item,
              customSteps: widget.customSteps,
              decimalPlaces: widget.customSteps != null ? 1 : 0,
              onChanged: (value) {
                print("from counter");
                if (value == 0 ) {
                  widget.onRemoveFromCart();
                } else {
                  widget.onChanged(value + .0);
                }
              },
            ),
          )
        ],
      );
    }
    return Row(
      children: <Widget>[
        RaisedButton.icon(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          onPressed: () {
            if (CartHelper().getCurrentStoreId() == null || CartHelper().getCurrentStoreId() == widget.item.storeId) {
              if (widget.customSteps != null && widget.customSteps.length > 0) {
                widget.onChanged(widget.customSteps[0]);
              } else {
                widget.onChanged(1.0);
              }
            }
            else{
              // show you have items from different stores
              PopupDialogs.showPosterPopUpWithAction(
                  context: context,
                  actionName: "Clear & Add",
                  onClickAction: () async {
                    await CartHelper().clearCart();
                    if (widget.customSteps != null && widget.customSteps.length > 0) {
                      widget.onChanged(widget.customSteps[0]);
                    } else {
                      widget.onChanged(1.0);
                    }
                  },
                  image:
                  "assets/images/empty_cart_illustration.png",
                  title: "Clear cart and add new item",
                  body:
                  "Your cart already contains items from another store. Do you want to clear cart and add this item ?");
            }
          },
          color: AppColors.MAIN_COLOR,
          icon: Image.asset(
            "assets/images/ic_nav_cart.png",
            height: 20,
          ),
          label: Container(
              child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                width: MediaQuery.of(context).size.width / 3 - 20,
                child: Text(
                  'add_to_cart',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.TEXT_WHITE),
                ).tr(),
              ),
            ),
          )),
        )
      ],
    );
  }
}

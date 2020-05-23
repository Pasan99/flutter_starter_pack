import 'package:auto_route/auto_route.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/order_details_view_model.dart';

class OrderItem extends StatefulWidget {
  final String storeName;
  final String price;
  final String orderNo;
  final String buttonText;
  final String date;
  final Order order;
  final String language;

  const OrderItem(
      {Key key,
      this.storeName,
      this.price,
      this.orderNo,
      this.buttonText,
      this.date,
      this.order,
      this.language})
      : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState(
        storeName: storeName,
        price: price,
        orderNo: orderNo,
        buttonText: buttonText,
        date: date,
        order: order,
        language: language,
      );
}

class _OrderItemState extends State<OrderItem> {
  final String storeName;
  final String price;
  final String orderNo;
  String buttonText;
  final String date;
  final Order order;
  final String language;

  _OrderItemState({
    this.storeName,
    this.price,
    this.orderNo,
    this.buttonText,
    this.date,
    this.order,
    this.language,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ExtendedNavigator.of(context).pushNamed(Routes.myOrderShopDetailPage,
            arguments: MyOrderShopDetailPageArguments(
                order: order, language: language, onOrderStatusChanged: (status){
                  setState(() {
                    buttonText = status;
                  });
            }));
      },
      child: Container(
        padding: EdgeInsets.only(top: 0, bottom: 3),
        child: Material(
          color: AppColors.BACK_WHITE_COLOR,
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Order No $orderNo',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.DARK_TEXT_COLOR),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Container(
                          width: 80,
                          height: 1,
                          color: AppColors.DIVIDER_COLOR,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Container(
                          child: Text(
                            storeName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.DARK_TEXT_COLOR),
                          ),
                        ),
                      ),
                      Text(
                        'LKR $price',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: AppColors.LIGHT_TEXT_COLOR),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      child: Text(
                        buttonText ==
                                    OrderDetailsViewModel.Customer_Cancelled ||
                                buttonText == OrderDetailsViewModel.Cancelled
                            ? "Canceled"
                            : buttonText,
                        style: TextStyle(
                          color: AppColors.TEXT_WHITE,
                          fontSize: 16,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0)),
                      color: buttonText ==
                          OrderDetailsViewModel.Customer_Cancelled ||
                          buttonText == OrderDetailsViewModel.Cancelled
                          ? AppColors.WARNING_NOTIFY_COLOR : AppColors.MAIN_COLOR,
                      onPressed: () async {},
                      elevation: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 12,
                          fontWeight: FontWeight.w300
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

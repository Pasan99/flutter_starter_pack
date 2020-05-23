import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_deliver/src/api/models/response/order_response_api.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/order_details_view_model.dart';
import 'package:provider/provider.dart';

class MyOrderShopDetailPage extends StatelessWidget {
  final Order order;
  final String language;
  final Function onOrderStatusChanged;

  const MyOrderShopDetailPage(
      {Key key, this.order, this.language, this.onOrderStatusChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
        title: Text(
          order == null || order.orderId == null || order.storeName == null
              ? 'Order no - Store name'
              : "Order no: ${order.orderId.toString()} - ${order.storeName[language.toLowerCase()]}",
          style: TextStyle(color: AppColors.TEXT_WHITE),
        ),
        backgroundColor: AppColors.MAIN_COLOR,
      ),
      body: MyOrderShopDetailPageBody(
        onOrderStatusChanged: onOrderStatusChanged,
        order: order,
        language: language.toLowerCase(),
      ),
    );
  }
}

class MyOrderShopDetailPageBody extends StatefulWidget {
  final Order order;
  String language;
  final Function onOrderStatusChanged;

  MyOrderShopDetailPageBody(
      {Key key, this.order, this.language, this.onOrderStatusChanged})
      : super(key: key);

  @override
  _MyOrderShopDetailPageBodyState createState() => _MyOrderShopDetailPageBodyState();
}

class _MyOrderShopDetailPageBodyState extends State<MyOrderShopDetailPageBody> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200)).then((val){
      try{
      setState(() {
        status = true;
      });
      }
      catch(e){
        print(e);
      }
    });
    Map<String, dynamic> map = widget.order.cityName;
    return ChangeNotifierProvider(
      create: (context) => OrderDetailsViewModel(widget.order),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Consumer<OrderDetailsViewModel>(
                      builder: (context, model, child) {
                    return model.CANCELLED
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Material(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24.0),
                                      child: Text(
                                        "Order Cancelled",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.WARNING_NOTIFY_COLOR),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    elevation: 5,
                                    color: AppColors.BACK_WHITE_COLOR,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: AppColors.BACK_WHITE_COLOR,
                              elevation: 5,
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          model.RECEIVED ?  AnimatedContainer(
                                            duration: Duration(milliseconds: 1000),
                                            curve: Curves.bounceOut,
                                            width: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            height: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
//                                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                                image: new AssetImage("assets/images/ic_order_submited.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ) : Container(
//                                            width: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                          ),
                                          Container(
//                                            width: 70,
                                            height: 40,
                                            child: Text(
                                              'Order Submitted',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: model.RECEIVED
                                                    ? FontWeight.bold
                                                    : FontWeight.w300,
                                                color: AppColors.DARK_TEXT_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          model.CONFIRMED ?  AnimatedContainer(
                                            duration: Duration(milliseconds: 1000),
                                            curve: Curves.bounceOut,
                                            width: model.CONFIRMED ? (status ? 40.0 : 0) : 40.0,
                                            height: model.CONFIRMED ? (status ? 40.0 : 0) : 40.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
//                                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                                image: new AssetImage("assets/images/ic_order_accepted.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ) : Container(
//                                            width: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                          ),
                                          Container(
//                                            width: 70,
                                            height: 40,
                                            child: Text(
                                              'Order Accepted',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: model.CONFIRMED
                                                    ? FontWeight.bold
                                                    : FontWeight.w300,
                                                color: AppColors.DARK_TEXT_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          model.PICKED_UP ?  AnimatedContainer(
                                            duration: Duration(milliseconds: 1000),
                                            curve: Curves.bounceOut,
                                            width: model.PICKED_UP ? (status ? 40.0 : 0) : 40.0,
                                            height: model.PICKED_UP ? (status ? 40.0 : 0) : 40.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
//                                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                                image: new AssetImage("assets/images/ic_order_picked_up.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ) : Container(
//                                            width: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                          ),
                                          Container(
//                                            width: 70,
                                            height: 40,
                                            child: Text(
                                              'Order Picked Up',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: model.PICKED_UP
                                                    ? FontWeight.bold
                                                    : FontWeight.w300,
                                                color: AppColors.DARK_TEXT_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          model.DELIVERED ?  AnimatedContainer(
                                            duration: Duration(milliseconds: 1000),
                                            curve: Curves.bounceOut,
                                            width: model.DELIVERED ? (status ? 40.0 : 0) : 40.0,
                                            height: model.DELIVERED ? (status ? 40.0 : 0) : 40.0,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
//                                                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                                image: new AssetImage("assets/images/ic_order_delivered.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ) : Container(
//                                            width: model.RECEIVED ? (status ? 40.0 : 0) : 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Colors.grey,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.0),
                                          ),
                                          Container(
//                                            width: 70,
                                            height: 40,
                                            child: Text(
                                              'Order Delivered',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: model.DELIVERED
                                                    ? FontWeight.bold
                                                    : FontWeight.w300,
                                                color: AppColors.DARK_TEXT_COLOR,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                  })),

              Divider(
                height: 25,
                color: AppColors.DARK_TEXT_COLOR,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 0, 0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                      child: Text(
                        'Order Details',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.DARK_TEXT_COLOR),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
                child: Material(
                  color: AppColors.BACK_WHITE_COLOR,
                  elevation: 5,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  "Order placed on : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.order.createdAt != null &&
                                          widget.order.createdAt.length > 19
                                      ? widget.order.createdAt.substring(0, 10) + "  |  " +
                                          widget.order.createdAt.substring(11, 19)
                                      : "-",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                        Consumer<OrderDetailsViewModel>(
                            builder: (context, model, child) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Visibility(
                              visible: !model.CANCELLED,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Text(
                                      "Order delivered on : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.order.deliveryCompletedDateAndTime != null &&
                                          widget.order.deliveryCompletedDateAndTime.length > 19
                                          ? widget.order.deliveryCompletedDateAndTime.substring(0, 10) + "  |  " +
                                          widget.order.deliveryCompletedDateAndTime.substring(11, 19)
                                          : "-",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Divider(
                            height: 1,
                            color: AppColors.DIVIDER_COLOR,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 12, 8),
                              child: Image.asset(
                                "assets/images/ic_location.png",
                                height: 40,
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: AppColors.DIVIDER_COLOR,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 0, 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                          (widget.order.houseNo == null
                                                  ? ' no house'
                                                  : widget.order.houseNo + ',') +
                                              (widget.order.street == null
                                                  ? ' no street'
                                                  : widget.order.street + "\n") +
                                              (widget.order.contactName == null
                                                  ? 'Full name'
                                                  : widget.order.contactName),
                                          textAlign: TextAlign.left,
                                          maxLines: 5,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 13.0,
                                              color:
                                                  AppColors.DARK_TEXT_COLOR)),
                                    )
                                  ],
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

              Consumer<OrderDetailsViewModel>(builder: (context, model, child) {
                return Visibility(
                  visible: !model.CONFIRMED && !model.CANCELLED,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Cancel order',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      onPressed: () {
                        PopupDialogs.showLoadingDialog(
                            context, "please_wait".tr());
                        PopupDialogs.showSimpleErrorWithDoublePop(
                            context: context,
                            title: "Cancel Order",
                            message:
                                "Are you sure you want to cancel this order?",
                            btnName: "Cancel Now",
                            btnIcon: Icon(Icons.cancel),
                            onClick: (context1) async {
                              Navigator.of(context1).pop();
                              PopupDialogs.isSimplePopClosed = true;

                              if (await model.cancelOrder(context)) {
                                model.setStatus(
                                    OrderDetailsViewModel.Customer_Cancelled);
                                Navigator.of(context).pop();
                                PopupDialogs.isShowingLodingDialog = false;
                                PopupDialogs.isSimplePopClosed = true;
                                widget.onOrderStatusChanged(
                                    OrderDetailsViewModel.Customer_Cancelled);
                                widget.order.status = OrderDetailsViewModel.Cancelled;
                                widget.order.status = OrderDetailsViewModel.Cancelled;
                              } else {
                                if (model.currentResponse ==
                                    Responses.NETWORK_DISCONNECTED) {
                                  PopupDialogs.isShowingLodingDialog = true;
                                  Navigator.pop(context);
                                  PopupDialogs.showSimplePopDialog(
                                      context,
                                      "Error",
                                      "Something went wrong. Please try again");
                                } else {
                                  Navigator.of(context).pop();
                                  PopupDialogs.isShowingLodingDialog = false;
                                  PopupDialogs.isSimplePopClosed = true;
                                  try {
                                    PopupDialogs.showSimplePopDialog(
                                        context,
                                        "Error",
                                        model.orderResponse != null &&
                                                model.orderResponse.errorBody !=
                                                    null
                                            ? model
                                                .orderResponse.errorBody.message
                                            : "Unknown Error occured");
                                  } catch (i) {
                                    Navigator.of(context).pop();
                                    PopupDialogs.isShowingLodingDialog = false;
                                    print("here");
                                    print(i);
                                  }
                                }
                              }
                            });
                      },
                    ),
                  ),
                );
              }),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 10, 0),
                child: Text(
                  'Order Items',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.DARK_TEXT_COLOR),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  color: AppColors.DIVIDER_COLOR,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: buildPackageList(widget.order),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  height: 1,
                  color: AppColors.DIVIDER_COLOR,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        child: Text(
                          "Cart subtotal",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300,
                              color: AppColors.DARK_TEXT_COLOR),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        child: Text(
                          'LKR ' +
                              (widget.order.transactionTotal != null ? (widget.order.transactionTotal - widget.order.feeTotal).toStringAsFixed(2) : "-"),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.DARK_TEXT_COLOR),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 10),
                child: Column(
                  children: widget.order.fees != null ? widget.order.fees.map((fee) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            child: Text(
                              fee.name != null ? fee.name : "-",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: AppColors.DARK_TEXT_COLOR),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            child: Text(
                              fee.amount != null
                                  ? 'LKR ' + fee.amount.toStringAsFixed(2)
                                  : "",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.DARK_TEXT_COLOR),
                            ),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          ),
                        ),
                      ],
                    );
                  }).toList() : <Widget>[Text("No Data")],
                ),
              ),
              Divider(
                height: 25,
                color: AppColors.DIVIDER_COLOR,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        child: Text(
                          "Total",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.DARK_TEXT_COLOR),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        child: Text(
                          'LKR ' + (widget.order.transactionTotal != null ? widget.order.transactionTotal.toStringAsFixed(2) : "-"),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.DARK_TEXT_COLOR),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                    ),
                  ],
                ),
              ),
//          Padding(
//            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//            child: Row(
//              children: <Widget>[
//                Expanded(
//                  child: Padding(
//                    child: Text(
//                      "Delivered on",
//                      style: TextStyle(
//                          fontSize: 15.0, color: AppColors.DARK_TEXT_COLOR),
//                    ),
//                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                  ),
//                ),
//                Expanded(
//                  child: Padding(
//                    child: Text(
//                      order.deliveryCompletedDateAndTime == null
//                          ? "no data"
//                          : order.deliveryCompletedDateAndTime,
//                      style: TextStyle(
//                          fontSize: 15.0, color: AppColors.DARK_TEXT_COLOR),
//                      textAlign: TextAlign.end,
//                    ),
//                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                  ),
//                ),
//              ],
//            ),
//          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPackageList(Order order) {
    List<Widget> widgetList = List();
    List<Item> packages = order.items;
    for (Item package in packages) {
      Map<String, dynamic> mapPackage = package.packageName;
      widgetList.add(buildPackage(
          mapPackage == null ? 'no details' : mapPackage[widget.language],
          package.perPackagePrice.toStringAsFixed(0),
          package.packageQty.toString(),
          package.total.toStringAsFixed(2)));
      if (package.packageItems != null) {
        for (PackageApi item in package.packageItems) {
          Map<String, dynamic> mapItem = item.productName;
          widgetList
              .add(buildItem(mapItem == null ? "" : item.product, item.qty));
        }
      }
    }

    return Column(
      children: widgetList,
    );
  }

  Widget buildPackage(String name, String amount, String qnt, String total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.LIGHTER_TEXT_COLOR,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            child: Text(
                              name == null ? 'name' : name,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.DARK_TEXT_COLOR),
                            ),
                            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          child: Text(
                            amount == null && qnt == null
                                ? 'amount'
                                : amount + " x " + qnt,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w300,
                                color: AppColors.DARK_TEXT_COLOR),
                          ),
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  child: Text(
                    "LKR $total",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.DARK_TEXT_COLOR),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 5, 8, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(String name, String qty) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              child: Text(
                name == null ? 'name' : name,
                style:
                    TextStyle(fontSize: 12.0, color: AppColors.DARK_TEXT_COLOR),
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            ),
          ),
          Expanded(
            child: Padding(
              child: Text(
                qty == null ? 'qty' : qty,
                style:
                    TextStyle(fontSize: 12.0, color: AppColors.DARK_TEXT_COLOR),
                textAlign: TextAlign.end,
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ui/widgets/order_item.dart';
import 'package:food_deliver/src/ui/widgets/shimmers/shimmer_list_1.dart';
import 'package:food_deliver/src/ui/widgets/store_animated_list.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/response_codes.dart';
import 'package:food_deliver/src/viewmodels/order_frag_viewmodel.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shimmer/shimmer.dart';

class MyOrderFragmentPage extends StatefulWidget {
  final Function onDirectToHome;

  MyOrderFragmentPage({Key key, this.onDirectToHome}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MYOrderFragmentPageState();
  }
}

class _MYOrderFragmentPageState extends State<MyOrderFragmentPage>
    with DataSetChangedListener {
  //final OrderFragViewModel _orderFragViewModel = OrderFragViewModel();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

//  List<Order> _orderList = List();
//  int _currentPageID = 1;
//  int pageSize = 10;
//  String language;
//  int totalOrderCount;

  @override
  void initState() {
//    getResponse();
    super.initState();
  }

//  getResponse() async {
//    try {
//      UserEntity user = await UserAuth().getCurrentUser();
//      language = user.language.toLowerCase();
//      OrderResponsePaginationApi tempResponse = await _orderFragViewModel
//          .getOrderPaginationData(context, _currentPageID, 10);
//      totalOrderCount = tempResponse.total;
//
//      if (tempResponse == null ||
//          tempResponse.itemList.isInvalid() ||
//          tempResponse.itemList[0].total == 0 ||
//          tempResponse.itemList[0].data.isInvalid()) return;
//
//      var indexes = [];
//      for (int i = 0; i < tempResponse.itemList[0].data.length; i++) {
//        if (tempResponse.itemList[0].data.any((item) =>
//            (item.orderId == tempResponse.itemList[0].data[i].orderId)))
//          indexes.add(i);
//      }
//
//      AnimatedListRemovedItemBuilder builder = (context, animation) {
//        // A method to build the Card widget.
//        return Container(
//          width: double.infinity,
//          height: 65,
//        );
//      };
//
//      this._orderList.clear();
//      this._orderList.addAll(tempResponse.itemList[0].data);
//
//      if (!indexes.isInvalid()) {
//        for (int i = 0; i < indexes.length; i++) {
//          try {
//            _listKey.currentState
//                .removeItem(i, builder, duration: Duration(milliseconds: 0));
//          } catch (e) {
//            print(e);
//          }
//
//          _listKey.currentState.insertItem(i);
//        }
//      }
//
//      _listKey.currentState.setState(() {});
//    } catch (e) {
//      print(e);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider(
        create: (context) => OrderFragViewModel(context),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
              centerTitle: true,
              elevation: 8,
              title: Text(
                "My Orders",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: AppColors.TEXT_WHITE),
              ),
              backgroundColor: AppColors.MAIN_COLOR,
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    text: "Ongoing Orders",
                  ),
                  Tab(
                    text: "Past Orders",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  color: AppColors.BACK_WHITE_COLOR,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Consumer<OrderFragViewModel>(
                      builder: (context, model, child) {
                        if (model.orderList.isInvalid()) {
                          if (model.currentResponse == Responses.NO_DATA) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SafeArea(
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 500),
                                        opacity: model.currentResponse == Responses.NO_DATA ? 1.0 : 0.0,
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 40,
                                          child: Image.asset(
                                            "assets/images/order_illustration.png",
                                          ),
                                        ),
                                      ),

                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                      child: Text(
                                        "You don't have past orders to show",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      "Create your first order",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200, fontSize: 12),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                                            child: ButtonTheme(
                                              height: 50,
                                              child: OutlineButton(
                                                splashColor: AppColors.LIGHT_MAIN_COLOR,
                                                focusColor: AppColors.TEXT_WHITE,
                                                highlightedBorderColor: AppColors.BACK_WHITE_COLOR,
                                                textColor: AppColors.MAIN_COLOR,
                                                color: AppColors.BACK_WHITE_COLOR,
                                                borderSide: BorderSide(color: AppColors.MAIN_COLOR),
                                                shape: new RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(8.0),
                                                ),
                                                onPressed: () {
                                                  // to do
                                                  widget.onDirectToHome();
                                                },
                                                child: Text(
                                                  'Start Shopping',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontStyle: FontStyle.normal,
                                                      color: AppColors.MAIN_COLOR),
                                                ).tr(),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (model.currentResponse == Responses.TIMEOUT) {
                            // no data view
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SafeArea(
                                    child: SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: Image.asset(
                                        "assets/images/no_internet.png",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                    child: Text(
                                      "connection_issue",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ).tr(),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(32, 0, 32, 0),
                                    child: Text(
                                      "Something_wrong_Please_try_again",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ).tr(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: OutlineButton(
                                      child: Text("retry").tr(),
                                      onPressed: () {
                                        model.getResponse(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
//                        return Center(
//                          child: SpinKitRotatingPlain(
//                            color: AppColors.MAIN_COLOR,
//                            size: 60.0,
//                          ),
//                        );
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: ShimmerListType1(),
                            );
                          }
                        } else {
                          return LoadMore(
                              isFinish: model.orderList.length >= model.total,
                              onLoadMore: model.loadMore,
                              child: ListView.builder(
                                key: _listKey,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index < model.orderList.length) {
                                    return OrderItem(
                                      storeName:
                                          model.orderList[index].convertedName,
                                      price: model.orderList[index].transactionTotal
                                          .toString(),
                                      orderNo: model.orderList[index].orderId
                                                  .toString() ==
                                              null
                                          ? 'xxx'
                                          : model.orderList[index].orderId
                                              .toString(),
                                      buttonText:
                                          model.orderList[index].status == null
                                              ? 'xxx'
                                              : model.orderList[index].status
                                                  .toString(),
                                      date: model.orderList[index].createdAt != null &&
                                          model.orderList[index].createdAt.length > 19
                                          ? model.orderList[index].createdAt.substring(0, 10) + "  |  " +
                                          model.orderList[index].createdAt.substring(11, 19)
                                          : "",
                                      order: model.orderList[index],
                                      language: model.language,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                                itemCount: model.orderList.length,
                              ),
                              delegate: DefaultLoadMoreDelegate(),
                              textBuilder: (status) {
                                if (status == LoadMoreStatus.nomore) {
                                  return "○○○○○○○○";
                                } else if (status == LoadMoreStatus.loading) {
                                  return "Loading";
                                } else {
                                  return "";
                                }
                              });
                        }
                      },
                    ),
                  ),
                ),
                Icon(Icons.bookmark_border)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  onOffsetChanged() {
    print("gjgjgkhgjkghjghjkghjk");
    return null;
  }

  @override
  onScrollDown() {
    print("gjgjgkhgjkghjghjkghjk");
    return null;
  }

  @override
  onScrollUp() {
    print("gjgjgkhgjkghjghjkghjk");
    return null;
  }
}

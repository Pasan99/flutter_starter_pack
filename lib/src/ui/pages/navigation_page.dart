// ignore: avoid_web_libraries_in_flutter
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ui/fragments/account_fragment_page.dart';
import 'package:food_deliver/src/ui/fragments/cart_fragment.dart';
import 'package:food_deliver/src/ui/fragments/home_fragment.dart';
import 'package:food_deliver/src/ui/fragments/my_orders_fragment.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/cart_helper.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/navigation_page_view_model.dart';
import 'package:food_deliver/src/viewmodels/order_details_view_model.dart';
import 'package:provider/provider.dart';

NavigationPageViewModel model = NavigationPageViewModel();

class NavigationPage extends StatelessWidget {
  static const String _title = 'Food Delivery';

  NavigationPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<String> names = ["Select a Store", "Your Cart", "Orders", "Account"];

  @override
  void initState() {
    super.initState();
    //start syncing contact details from server
    //ContactSyncHandler().syncContacts(null);
//    CartHelper().clearCart();
    _setFirebaseConfigurations();
  }

  _setFirebaseConfigurations() async {
    UserEntity currentUser = await UserAuth().getCurrentUser();
    print(currentUser.authId);
    _firebaseMessaging.subscribeToTopic(currentUser.authId);
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print(message);
      PopupDialogs.showSimplePopDialogWithImage(
          context: context,
          title: message["data"]["title"].toString() +
              " : Order No " +
              message["data"]["orderNo"].toString(),
          message: message["data"]["message"].toString(),
          imageUrl: _getImage(message["data"]["status"].toString()));
      // go to orders screen
      setState(() {
        _selectedIndex = 2;
      });
    }, onResume: (Map<String, dynamic> message) async {
      print(message);
      PopupDialogs.showSimplePopDialogWithImage(
          context: context,
          title: message["data"]["title"].toString() +
              " : Order No " +
              message["data"]["orderNo"].toString(),
          message: message["data"]["message"].toString(),
          imageUrl: _getImage(message["data"]["status"].toString()));
      setState(() {
        _selectedIndex = 2;
      });
    }, onLaunch: (Map<String, dynamic> message) async {
      print(message);
      PopupDialogs.showSimplePopDialogWithImage(
          context: context,
          title: message["data"]["title"].toString() +
              " : Order No " +
              message["data"]["orderNo"].toString(),
          message: message["data"]["message"].toString(),
          imageUrl: _getImage(message["data"]["status"].toString()));
      setState(() {
        _selectedIndex = 2;
      });
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  _getImage(String status) {
    String url = "";
    switch (status) {
      case OrderDetailsViewModel.Received:
        url = "assets/images/ic_order_submited.png";
        break;
      case OrderDetailsViewModel.Confirmed:
        url = "assets/images/ic_order_accepted.png";
        break;
      case OrderDetailsViewModel.Scheduled:
        url = "assets/images/ic_order_accepted.png";
        break;
      case OrderDetailsViewModel.Picked_Up:
        url = "assets/images/ic_order_picked_up.png";
        break;
      case OrderDetailsViewModel.On_Route:
        url = "assets/images/ic_order_picked_up.png";
        break;
      case OrderDetailsViewModel.Delivered:
        url = "assets/images/ic_order_delivered.png";
        break;
      case OrderDetailsViewModel.Cancelled:
        url = "assets/images/no_order.png";
        break;
      case OrderDetailsViewModel.Customer_Cancelled:
        url = "assets/images/no_order.png";
        break;
    }
    return url;
  }

  _MyStatefulWidgetState() {
    _widgetOptions = <Widget>[
//      StoreSelectionFragment(
//        onCartItemChanged: (count) {
//          model.setCount(count);
//        },
//        onCartPressed: () {
//          _onItemTapped(1);
//        },
//      ),
      HomeFragment(onCartPressed: () async {
        model.setCount((await CartHelper().getCartItemCount()).toDouble());
        _onItemTapped(1);
      }),
      CartFragment(
        onOrderPlaced: (){
          _onItemTapped(2);
        },
        onCartItemChanged: (count) async {
          model.setCount((await CartHelper().getCartItemCount()).toDouble());
        },
      ),
      MyOrderFragmentPage(
        onDirectToHome: (){
          _onItemTapped(0);
        },
      ),
      AccountFragmentPage(
        onCartCleared: () {
          model.setCount(0);
        },
      ),
    ];
  }

  List<Widget> _widgetOptions;

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    model.setCount((await CartHelper().getCartItemCount()).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
        return Future.value(false);
      },
      child: ChangeNotifierProvider(
        create: (context) => model,
        child: Scaffold(
          appBar: _selectedIndex != 2 && _selectedIndex != 0 && _selectedIndex != 1
              ? AppBar(
                  iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
                  centerTitle: true,
                  elevation: 0,
                  title: Text(
                    names[_selectedIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, color: AppColors.TEXT_WHITE),
                  ),
                  backgroundColor: AppColors.MAIN_COLOR,
                )
              : null,
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 10,
            selectedLabelStyle: TextStyle(color: AppColors.MAIN_COLOR),
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Image.asset(
                    "assets/images/ic_nav_home.png",
                    height: 20,
                  ),
                ),
                title: Column(
                  children: <Widget>[
                    Container(
                      height: 4,
                    ),
                    Text(
                      'home',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ).tr(),
                    Container(
                      height: 4,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                icon: Consumer<NavigationPageViewModel>(
                    builder: (context, model, child) {
                  if (model.cartItemCount != 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: new Stack(
                        children: <Widget>[
                          new Image.asset(
                            "assets/images/ic_nav_cart.png",
                            height: 20,
                          ),
                          new Positioned(
                            right: 0,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: AppColors.WARNING_NOTIFY_COLOR,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: new Text(
                                model.cartItemCount.toStringAsFixed(0),
                                style: new TextStyle(
                                  color: AppColors.TEXT_WHITE,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Image.asset(
                        "assets/images/ic_nav_cart.png",
                        height: 20,
                      ),
                    );
                  }
                }),
                title: Column(
                  children: <Widget>[
                    Container(
                      height: 4,
                    ),
                    Text('cart',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12))
                        .tr(),
                    Container(
                      height: 4,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Image.asset(
                    "assets/images/ic_nav_orders.png",
                    height: 20,
                  ),
                ),
                title: Column(
                  children: <Widget>[
                    Container(
                      height: 4,
                    ),
                    Text('orders',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                            ))
                        .tr(),
                    Container(
                      height: 4,
                    ),
                  ],
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Image.asset(
                    "assets/images/ic_nav_account.png",
                    height: 20,
                  ),
                ),
                title: Column(
                  children: <Widget>[
                    Container(
                      height: 4,
                    ),
                    Text('account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                            ))
                        .tr(),
                    Container(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.BOTTOM_NAVIGATION_SELECTED_ICON_COLOR,
            unselectedItemColor:
                AppColors.BOTTOM_NAVIGATION_UNSELECTED_ICON_COLOR,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

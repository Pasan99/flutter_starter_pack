import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/db_controller.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/configurations_entity.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/db/entity/fees_entity.dart';
import 'package:food_deliver/src/db/entity/order_entity.dart';
import 'package:food_deliver/src/db/entity/package_entity.dart';
import 'package:food_deliver/src/db/entity/product_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ui/pages/registration/getting_started_page.dart';
import 'package:food_deliver/src/ui/pages/navigation_page.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/values/strings.dart';
import 'package:food_deliver/src/viewmodels/config_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:food_deliver/src/ext/string_extension.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    _mockCheckForSession();
  }

  Future<void> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () async {
      _createDB();
    });
  }

  void _navigateTostart() {
    ExtendedNavigator.rootNavigator.pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => GettingStartedScreen()));
//    Navigator.of(context).pop();
//    ExtendedNavigator.of(context).pushNamed(
//        Routes.gettingStartedScreen);
  }

  void _navigateToHome() {
    ExtendedNavigator.rootNavigator.pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => NavigationPage()));
//    Navigator.of(context).pop();
//    ExtendedNavigator.of(context).pushNamed(
//        Routes.navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
//          Center(
//            child: Image.asset(
//              'assets/images/chapz_icon_01.png',
//              width: 200,
//              height: 200,
//            ),
//          ),
          Center(
            child: Container(
              child: Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    Strings.APP_NAME,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Powered by',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.w300
                  ),
                ),
                Text(
                  'RUMEX',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _createDB() async {
    UserEntity currentUser;
    try {
      await DBController().configureDBEntities([
        UserEntity(),
        PackageEntity(),
        CartItemEntity(),
        DistrictEntity(),
        CityEntity(),
        ConfigurationsEntity(),
        FeesEntity(),
        ContactEntity(),
        OrderEntity(),
        ProductEntity()
      ]);
      Database db = await DBController().getDB();
      if (db != null) {
        currentUser = await UserAuth().getCurrentUser();
        if (currentUser != null && !currentUser.accessToken.isInvalid()) {
//          await ConfigViewModel().getAndSaveConfig(null);
//          await CreateDistrictAndCityViewModel()
//              .retrieveAndSaveDisWithCities(null);
          if (currentUser.name != null) {
            _navigateToHome();
            return Future.value(true);
          }
        }
        _navigateTostart();
        return Future.value(true);
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      PopupDialogs.showSimpleNetworkRetry(context, "Network Error", "No internet connection. Please make sure WiFI or mobile data is on and try again.", (){
        Navigator.pop(context);
        PopupDialogs.isSimplePopClosed = true;
        _createDB();
      });
//      if (currentUser.name != null) {
//        _navigateToHome();
//        return Future.value(false);
//      }
//      _navigateTostart();
//      return Future.value(false);
    }
  }
}

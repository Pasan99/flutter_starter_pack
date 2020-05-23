import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:google_api_availability/google_api_availability.dart';

import '../../../models/slide.dart';
import '../../../routes/router.gr.dart';
import '../../widgets/slide_dots.dart';
import '../../widgets/slide_item.dart';

class GettingStartedScreen extends StatefulWidget {

  GettingStartedScreen({Key key}) : super(key: key);

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  /// google play services availability checker for android*******
  GooglePlayServicesAvailability _playStoreAvailability =
      GooglePlayServicesAvailability.unknown;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkPlayServices([bool showDialog = false]) async {
    GooglePlayServicesAvailability playStoreAvailability;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      playStoreAvailability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability(showDialog);
    } on Exception {
      playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _playStoreAvailability = playStoreAvailability;
    });
  }

  ///******************************************************************

  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  Timer _pageAnimateTimer;

  String sliderText = 'Groceries, dairy & meat products, beverages and more delivered to your doorstep';

  String text1 = "Groceries, dairy & meat products, beverages and more delivered to your doorstep";

  String text2 = 'Find stores near you, browse their products and have your orders on the way with a few simple steps';

  String text3 = '24/7 shopping from the comfort of your home';

  String heading = "Everyday Essentials";
  String heading1 = "Everyday Essentials";
  String heading2 = "Quick and Simple";
  String heading3 = "Hassle Free Shopping";

  bool _isStop = false;
  int _idleTime = 0;
  final int _idle = 10;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) checkPlayServices(true);

    _pageAnimateTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_idleTime > _idle){
        _idleTime = 0;
        _isStop = false;
      }
      if (!_isStop) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        setState(() {
          _currentPage == 0
              ? sliderText = text1
              : _currentPage == 1 ? sliderText = text2 : sliderText = text3;

          _currentPage == 0
              ? heading = heading1
              : _currentPage == 1 ? heading = heading2 : heading = heading3;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
      else{
        _idleTime+= 5;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    try {
      if (_pageController != null) _pageController.dispose();
      if (_pageAnimateTimer != null) _pageAnimateTimer.cancel();
    } catch (e) {
      print(e);
    }
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;

      _currentPage == 0
          ? sliderText = text1
          : _currentPage == 1 ? sliderText = text2 : sliderText = text3;

      _currentPage == 0
          ? heading = heading1
          : _currentPage == 1 ? heading = heading2 : heading = heading3;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _isStop = true;
        });
      },
      onHorizontalDragStart: (val){
        setState(() {
          _isStop = true;
        });
      },
      onVerticalDragStart: (val){
        setState(() {
          _isStop = true;
        });
      },
      child: Scaffold(
        body: Container(
          color: AppColors.BACK_WHITE_COLOR,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: slideList.length,
                        itemBuilder: (ctx, i) => SlideItem(i),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white,
                                Colors.white70,
                                Colors.white54,
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                        height: (MediaQuery.of(context).size.height / 12) * 3.5,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 85),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0; i < slideList.length; i++)
                                  if (i == _currentPage)
                                    SlideDots(true)
                                  else
                                    SlideDots(false)
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 80,
                        width: 150,
                        padding: EdgeInsets.only(bottom: 24, top: 12),
                        child: MaterialButton(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Get Started",
                              style: TextStyle(color: AppColors.TEXT_WHITE, fontSize: 15),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: AppColors.MAIN_COLOR)),
                          color: AppColors.MAIN_COLOR,
                          onPressed: () {
                            _navigate();
                          },
                          elevation: 4,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: 180,
                        ),
                        child: Text(heading, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          bottom: 110,
                        ),
                        child: Text(sliderText),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
//      floatingActionButton: FloatingActionButton.extended(
//          label: Text(
//            "Get Started",
//            style: TextStyle(color: Colors.green,fontSize: 15),
//          ),
//          elevation: 2,
//          backgroundColor: Colors.white,
//          onPressed: () async {
////          print('Clicked');
////          ExtendedNavigator.of(context).pushNamed(Routes.language_select_page);
////          },
////            pr.show();
////            Future.delayed(Duration(seconds: 1)).then((value) {
////              pr.hide().whenComplete(() async {
////                navigate();
////              });
////            });
//
//            _navigate();
//          }),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _navigate() async {
    UserEntity currentUser = await UserAuth().getCurrentUser();
    if (currentUser == null) {
      // Language Screen
//      ExtendedNavigator.of(context).pushNamed(Routes.language_select_page);
      ExtendedNavigator.rootNavigator.pushReplacementNamed(Routes.pickLanguagePage); //new language page
    } else if (!currentUser.language.isInvalid() &&
        !currentUser.mobileNumber.isInvalid() &&
        !currentUser.name.isInvalid()) {
      // Home Screen
      ExtendedNavigator.rootNavigator.pushReplacementNamed(Routes.navigationPage);
    } else if (!currentUser.language.isInvalid() &&
        !currentUser.mobileNumber.isInvalid() &&
        !currentUser.accessToken.isInvalid()) {
      // Registration Screen
      ExtendedNavigator.rootNavigator.pushReplacementNamed(Routes.locationRegisterPage,
          arguments: LocationRegisterPageArguments(
            onSave: (){},
              onContactCreated: (){},
              registrationType:
                  LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS));
    } else if (!currentUser.language.isInvalid()) {
      // Mobile number Screen
      ExtendedNavigator.rootNavigator
          .pushReplacementNamed(Routes.phoneNumberRegisterPage);
    }
  }
}

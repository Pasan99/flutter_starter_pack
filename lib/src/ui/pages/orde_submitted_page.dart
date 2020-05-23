import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:food_deliver/src/values/colors.dart';

class OrderSubmittedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.BACK_WHITE_COLOR,
          child: OrderSubmittedPageBody()
      ),
    );
  }
}

class OrderSubmittedPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                            'assets/images/order_confirmed_illustration.png',
                          width: MediaQuery.of(context).size.width - 40,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                    ExtendedNavigator.of(context).pop();
                                  },
                                  child: Text(
                                    'View Order',
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
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: ListView(
                  children: <Widget>[
                    Text('order_submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.DARK_TEXT_COLOR
                      ),
                    ).tr(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Text('order_submit_msg',
                            textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.DARK_TEXT_COLOR
                        ),
                      ).tr(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';

import '../../../routes/router.gr.dart';
import '../registration/location_map_page.dart';

class SelectAddressPage extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
        title: Text(
          'Select address',
          style: TextStyle(color: AppColors.DARK_TEXT_COLOR),
        ),
        backgroundColor: AppColors.MAIN_COLOR,
        elevation: 0,
      ),
      body: SelectAddressPage_body(),
    );
  }
}

class SelectAddressPage_body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 16),
                    child: Container(
                        width: 160,
                        height: 340,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                          child: Material(
                            color: AppColors.BACK_WHITE_COLOR,
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "My Information",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.DARK_TEXT_COLOR),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Personal Information",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.LIGHT_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Full name",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "full name",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "NIC No",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "87366363v",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Contact number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "077863533",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 24, 0, 0),
                                        child: Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Colombo",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Bambalapitiya",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Main road / village",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Street No",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "House No. / Apartment No.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 16),
                    child: Container(
                        width: 160,
                        height: 340,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                          child: Material(
                            color: AppColors.BACK_WHITE_COLOR,
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Contact Information",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.DARK_TEXT_COLOR),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Personal Information",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.LIGHT_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Full name",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "full name",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "NIC No",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "87366363v",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        child: Text(
                                          "Contact number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(5, 10, 0, 0),
                                      ),
                                      Padding(
                                        child: Text(
                                          "077863533",
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 24, 0, 0),
                                        child: Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.DARK_TEXT_COLOR),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Colombo",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Bambalapitiya",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Main road / village",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "Street No",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                  Row(children: <Widget>[
                                    Padding(
                                      child: Text(
                                        "House No. / Apartment No.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.DARK_TEXT_COLOR),
                                      ),
                                      padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
                    child: InkWell(
                      child: Text(
                        'Add a new contact',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.0,
                            decoration: TextDecoration.underline,
                            color: AppColors.DARK_TEXT_COLOR),
                      ),
                      onTap: () {
                        ExtendedNavigator.of(context).pushNamed(
                            Routes.locationMapPage,
                            arguments: LocationMapPageArguments(
                                registrationType: LocationMapPage
                                    .REGISTRATION_TYPE_SUB_ADDRESS));
                        print("hi");
                      },
                    )),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: ButtonTheme(
                      height: 50,
                      child: RaisedButton(
                        color: AppColors.MAIN_COLOR,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          ExtendedNavigator.of(context)
                              .pushNamed(Routes.checkoutPage);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                              fontSize: 22, fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

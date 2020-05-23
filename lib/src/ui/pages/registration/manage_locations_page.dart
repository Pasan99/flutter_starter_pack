import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/ui/widgets/store_animated_list.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/viewmodels/manage_locations_viewmodel.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:food_deliver/src/ui/dialogs/PopUpDialog.dart';

class ManageLocationsPage extends StatefulWidget {
  final Function onCartCleared;

  const ManageLocationsPage({Key key, @required this.onCartCleared})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ManageLocationsPageState();
  }
}

class _ManageLocationsPageState extends State<ManageLocationsPage> {
  ManageLocationViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ManageLocationViewModel(callback: callBackAfterListUpdate);
    super.initState();
    _viewModel.loadContactDetails(); //load all contacts
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.TEXT_WHITE),
          title: Text(
            'Locations',
            style: TextStyle(color: AppColors.TEXT_WHITE),
          ),
          backgroundColor: AppColors.MAIN_COLOR,
        ),
        body: Container(
          color: AppColors.BACK_WHITE_COLOR,
          child: Consumer<ManageLocationViewModel>(
            builder: (context, model, child) {
              BuildContext ctx = context;
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: ListView(
                          children: model.userContacts != null &&
                                  model.userContacts.length > 0
                              ? model.userContacts.map((contact) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 7, 16, 7),
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                                        child: Material(
                                          color: AppColors.BACK_WHITE_COLOR,
                                          elevation: 5.0,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 15, 15),
                                            child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 18, 0, 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Icon(Icons.person),
                                                      ),
                                                      Expanded(
                                                        flex: 7,
                                                        child: Text(
                                                          'personal_information',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color: AppColors
                                                                  .DARK_TEXT_COLOR),
                                                        ).tr(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 16, 8, 0),
                                                  child: Divider(
                                                    color:
                                                        AppColors.DIVIDER_COLOR,
                                                    height: 1,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 16, 0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          child: Text(
                                                            'full_name',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .DARK_TEXT_COLOR),
                                                          ).tr(),
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  5, 5, 0, 0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        child: Text(
                                                          contact.name ?? '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: AppColors
                                                                  .DARK_TEXT_COLOR),
                                                        ),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                30, 5, 0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 0, 16, 0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Padding(
                                                          child: Text(
                                                            'contact_no',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15.0,
                                                                color: AppColors
                                                                    .DARK_TEXT_COLOR),
                                                          ).tr(),
                                                          padding:
                                                              EdgeInsets.fromLTRB(
                                                                  5, 5, 0, 0),
                                                        ),
                                                      ),
                                                      Padding(
                                                        child: Text(
                                                          contact.contactNumber ??
                                                              '',
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: AppColors
                                                                  .DARK_TEXT_COLOR),
                                                        ),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                30, 10, 0, 0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 24, 0, 0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex: 1,
                                                        child: Icon(Icons.home),
                                                      ),
                                                      Expanded(
                                                        flex: 7,
                                                        child: Text(
                                                          'address',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              color: AppColors
                                                                  .DARK_TEXT_COLOR),
                                                        ).tr(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 16, 8, 0),
                                                  child: Divider(
                                                    color:
                                                        AppColors.DIVIDER_COLOR,
                                                    height: 1,
                                                  ),
                                                ),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      child: Text(
                                                        contact.houseNo != null
                                                            ? "No : " +
                                                                contact.houseNo
                                                            : '',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .DARK_TEXT_COLOR),
                                                      ),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              12, 16, 16, 0),
                                                    ),
                                                  ),
                                                ]),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                    child: Padding(
                                                      child: Text(
                                                        contact.street ?? '',
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: AppColors
                                                                .DARK_TEXT_COLOR),
                                                      ),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              12, 5, 16, 24),
                                                    ),
                                                  ),
                                                ]),
                                                Row(children: <Widget>[
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: OutlineButton.icon(
                                                      onPressed: () =>
                                                          _openUpdateLocationPage(
                                                              model,
                                                              model.userContacts
                                                                  .indexOf(
                                                                      contact)),
                                                      icon: Icon(Icons.edit),
                                                      label: Text(''),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 0, 0),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: OutlineButton.icon(
                                                      onPressed: () {
                                                        PopupDialogs
                                                            .showSimpleConfirmWithDoublePop(
                                                          context: context,
                                                          title: "Delete message",
                                                          message:
                                                              "Are you sure you want to delete this location.",
                                                          btnName: "Delete",
                                                          btnIcon:
                                                              Icon(Icons.delete),
                                                          onClick:
                                                              (context) async {
                                                            Navigator.of(context)
                                                                .pop();
                                                            _removeSelectedLocation(
                                                                model,
                                                                model.userContacts
                                                                    .indexOf(
                                                                        contact),
                                                                ctx);
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.delete),
                                                      label: Text(''),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 0, 0),
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList()
                              : <Widget>[Text("")],
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ButtonTheme(
                                  height: 50,
                                  child: OutlineButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(16.0),
                                    ),
                                    splashColor: AppColors.LIGHT_MAIN_COLOR,
                                    focusColor: AppColors.TEXT_WHITE,
                                    highlightedBorderColor: AppColors.BACK_WHITE_COLOR,
                                    textColor: AppColors.MAIN_COLOR,
                                    color: AppColors.BACK_WHITE_COLOR,
                                    borderSide: BorderSide(color: AppColors.MAIN_COLOR),
                                    onPressed: () async {
                                      ExtendedNavigator.rootNavigator
                                          .pushNamed(Routes.locationRegisterPage,
                                              arguments:
                                                  LocationRegisterPageArguments(
                                                      onContactCreated:
                                                          (contactId) {
                                                        _viewModel
                                                            .loadContactDetails();
                                                      },
                                                      registrationType:
                                                          LocationMapPage
                                                              .REGISTRATION_TYPE_SUB_ADDRESS))
                                          .then((value) {
                                        if (value == 1) {
                                          model.loadContactDetails();
                                        }
                                      });
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Add New Location',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                          color: AppColors.MAIN_COLOR),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: model.userContacts == null ||
                        model.userContacts.length == 0,
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/delivery_address_illustration.png",
                              width: MediaQuery.of(context).size.width - 60,
                            ),
                            Container(
                              height: 12,
                            ),
                            Text(
                              'No locations added',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.DARK_TEXT_COLOR,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  ///open location screen to update already created location
  void _openUpdateLocationPage(ManageLocationViewModel model, int index) async {
    try {
      var value = await ExtendedNavigator.rootNavigator.pushNamed(
          Routes.locationRegisterPage,
          arguments: LocationRegisterPageArguments(
              onSave: () {
                // update date
                _viewModel.loadContactDetails();
              },
              registrationType:
                  LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS,
              contactId: model.userContacts[index].contactID));

      if (value == 1) {
        model.loadContactDetails();
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  ///remove selected location from the server and the DB
  void _removeSelectedLocation(
      ManageLocationViewModel model, int index, BuildContext context) async {
    try {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Removing contact."),
      ));
      if (await model.removeSelectedLocation(
          model.userContacts[index].contactID, context)) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Contact removed successfully."),
        ));

        widget.onCartCleared();

        //re-load contact details
        model.loadContactDetails();

        // set current users
        UserEntity currentUser = await UserAuth().getCurrentUser();
        currentUser.selectedContactId = "me";

        return;
      }
    } catch (e) {
      print(e);
    }

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Contact remove failed. Please retry."),
    ));
  }

  void callBackAfterListUpdate() {
    setState(() {});
  }
}

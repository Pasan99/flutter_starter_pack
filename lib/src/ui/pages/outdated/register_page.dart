import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_deliver/src/api/models/request/contacts_request_api.dart';
import 'package:food_deliver/src/db/dao/city_dao.dart';
import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/dao/district_dao.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/list_extension.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/ui/pages/navigation_page.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:food_deliver/src/viewmodels/create_user_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  final LatLng selectedLocation;
  final int registrationType;
  final String contactID;
  final Function onContactCreated;

  RegistrationPage(this.registrationType, this.selectedLocation,
      {Key key, this.contactID, this.onContactCreated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistrationPageBodyState(
      this.registrationType, this.selectedLocation, this.contactID,
      onContactCreated: this.onContactCreated);
}

class _RegistrationPageBodyState extends State<RegistrationPage> {
  final LatLng _selectedLocation;
  final int _registrationType;
  final String _contactID;
  final Function onContactCreated;

  final _formKey = GlobalKey<FormState>();
  bool _isEnable = true;

  UserEntity _currentUser;

  _RegistrationPageBodyState(
      this._registrationType, this._selectedLocation, this._contactID,
      {this.onContactCreated});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.DARK_TEXT_COLOR),
        title: Text(
          _registrationType ==
                      LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS ||
                  _registrationType ==
                      LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS
              ? "select_your_delivery_address"
              : 'delivery_address',
          style: TextStyle(color: AppColors.DARK_TEXT_COLOR),
        ).tr(),
        backgroundColor: AppColors.MAIN_COLOR,
      ),
      body: WillPopScope(
        onWillPop: () => Future.value(true),
        child: ChangeNotifierProvider(
          create: (context) {
            CreateUserViewModel model = CreateUserViewModel();
            if (_registrationType ==
                LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS)
              _loadUserDetails(model); //load current user details
            else if (_registrationType ==
                LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS)
              _loadContactDetails(model); //load current contact details
            return model;
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Form(
              key: _formKey,
              child: Consumer<CreateUserViewModel>(
                  builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 10),
                          child: Text(
                            'personal_information',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.LIGHT_TEXT_COLOR_MIDDLE),
                          ).tr(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 8, 8),
                                  child: TextFormField(
                                    controller: model.firstName,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'first_Name'.tr(),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'required'.tr();
                                      }
                                      return null;
                                    },
                                  )),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                                child: TextFormField(
                                  controller: model.lastName,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'last_Name'.tr(),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'required'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Visibility(
                              visible: (_registrationType ==
                                  LocationMapPage
                                      .REGISTRATION_TYPE_MAIN_ADDRESS),
                              child: Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: TextFormField(
                                    controller: model.nic,
                                    maxLength: 12,
                                    decoration: InputDecoration(
                                      hintText: 'example_nic'.tr(),
                                      border: OutlineInputBorder(),
                                      labelText: _registrationType ==
                                                  LocationMapPage
                                                      .REGISTRATION_TYPE_SUB_ADDRESS ||
                                              _registrationType ==
                                                  LocationMapPage
                                                      .REGISTRATION_TYPE_EDIT_SUB_ADDRESS
                                          ? 'nic_opt'.tr()
                                          : 'nic_no'.tr(),
                                    ),
                                    validator: (value) {
                                      if (_registrationType ==
                                              LocationMapPage
                                                  .REGISTRATION_TYPE_SUB_ADDRESS ||
                                          _registrationType ==
                                              LocationMapPage
                                                  .REGISTRATION_TYPE_EDIT_SUB_ADDRESS) {
                                        return null;
                                      }

                                      if (value.isEmpty) {
                                        return 'required'.tr();
                                      }

                                      RegExp nicStructure =
                                          new RegExp(r"^[0-9]{9}[Vv]");
                                      if (nicStructure.hasMatch(value) ||
                                          value.length == 12) {
                                        return null;
                                      }
                                      return 'enter_valid_NIC'.tr();
                                    },
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp("[a-zA-Z0-9]"))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: (_registrationType ==
                              LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: TextFormField(
                                    controller: model.contactNo,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      hintText: "Ex: 0110000000",
                                      border: OutlineInputBorder(),
                                      labelText: 'contact_no'.tr(),
                                    ),
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'required'.tr();
                                      }
                                      RegExp nicStructure =
                                          new RegExp(r"^[0-9]{9}");
                                      if (nicStructure.hasMatch(value) ||
                                          value.length == 10) {
                                        return null;
                                      }
                                      return 'enter_valied_contact'.tr();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                          child: Text(
                            'delivery_info',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.LIGHT_TEXT_COLOR_MIDDLE),
                          ).tr(),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: ValueListenableBuilder(
                                  valueListenable: model.district,
                                  builder: (BuildContext context,
                                      TextEditingController controller,
                                      Widget child) {
                                    return TextFormField(
                                      controller: controller,
                                      onTap: () {
                                        ExtendedNavigator.rootNavigator
                                            .pushNamed(
                                                Routes.locationSelectPage,
                                                arguments:
                                                    LocationSelectPageArguments(
                                                  model: model,
                                                  isDistrict: true,
                                                ));
                                      },
                                      readOnly: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'required'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'district'.tr(),
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        suffixIcon: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: ValueListenableBuilder(
                                  valueListenable: model.city,
                                  builder: (BuildContext context,
                                      TextEditingController controller,
                                      Widget child) {
                                    return TextFormField(
                                      controller: controller,
                                      onTap: () {
                                        if (model.districtId == -1) {
                                          Scaffold.of(context)
                                              .removeCurrentSnackBar();
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                                "please select district before city"),
                                          ));
                                          return;
                                        }

                                        ExtendedNavigator.rootNavigator
                                            .pushNamed(
                                                Routes.locationSelectPage,
                                                arguments:
                                                    LocationSelectPageArguments(
                                                  model: model,
                                                  isDistrict: false,
                                                ));
                                      },
                                      readOnly: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'required'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'city'.tr(),
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        suffixIcon: Icon(
                                          Icons.arrow_drop_down,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                                child: TextFormField(
                                  controller: model.mainRoad,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Main_road_village'.tr(),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'required'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: TextFormField(
                                  controller: model.street,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: _registrationType ==
                                        LocationMapPage
                                            .REGISTRATION_TYPE_SUB_ADDRESS || _registrationType ==
                                        LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS
                                        ? 'street_no_opt'.tr()
                                        : 'street_no_otp'.tr(),
                                  ),
                                  validator: (value) {
                                    if (_registrationType ==
                                        LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS || _registrationType ==
                                        LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS ) {
                                      return null;
                                    }
                                    if (value.isEmpty) {
                                      return 'required'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                child: TextFormField(
                                  controller: model.houseNo,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'HouseNo_ApartmentNo'.tr(),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'required'.tr();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: TextField(
                                  controller: model.landMarks,
                                  decoration: InputDecoration(
                                    hintText: 'example_landmark'.tr(),
                                    border: OutlineInputBorder(),
                                    labelText: 'landmark_opt'.tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 16, 0, 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ButtonTheme(
                                    height: 50,
                                    child: CupertinoButton(
                                      color: AppColors.MAIN_COLOR,
//                                        shape: new RoundedRectangleBorder(
//                                          borderRadius: new BorderRadius
//                                              .circular(30.0),
//                                        ),
                                      onPressed: () =>
                                          _startRegistrationProcess(
                                              model, context),
                                      child: Text(
                                        _registrationType ==
                                                    LocationMapPage
                                                        .REGISTRATION_TYPE_EDIT_MAIN_ADDRESS ||
                                                _registrationType ==
                                                    LocationMapPage
                                                        .REGISTRATION_TYPE_EDIT_SUB_ADDRESS ||
                                                _registrationType ==
                                                    LocationMapPage
                                                        .REGISTRATION_TYPE_SUB_ADDRESS
                                            ? 'save'
                                            : 'register',
                                        style: TextStyle(
                                            color: AppColors.DARK_TEXT_COLOR,
                                            fontWeight: FontWeight.w400),
                                      ).tr(),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  ///start user address registration process with given [model]
  Future<void> _startRegistrationProcess(
      CreateUserViewModel model, BuildContext context) async {
    try {
      model.selectedLocation = _selectedLocation; //set selected location
      //validate the form and show error if invalid
      if (!_formKey.currentState.validate()) {
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text('please_enter_valid_Information').tr(),
        ));
        return Future.value();
      }

      String message = 'setting_up_account';
      if (_registrationType ==
          LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS)
        message = "Updating user...";
      else if (_registrationType ==
          LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS)
        message = "creating_contact";
      else if (_registrationType ==
          LocationMapPage.REGISTRATION_TYPE_EDIT_SUB_ADDRESS)
        message = "Updating contact...";

      //show login progress
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new CircularProgressIndicator(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: new Text(message).tr(),
                  ),
                ],
              ),
            ),
          );
        },
      );

      //disable button and start registration
      if (_isEnable) {
        _isEnable = false;

        if (_registrationType ==
                LocationMapPage.REGISTRATION_TYPE_MAIN_ADDRESS ||
            _registrationType ==
                LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS)
          await _registerMainAddress(model, context);
        else
          await _registerSubAddress(model, context);

        _isEnable = true;
      }
    } catch (e) {
      print(e);
      _isEnable = true;

      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('error_occurred').tr(),
      ));
    }

    return Future.value();
  }

  ///if user selects to register the main address details execute this method
  Future<void> _registerMainAddress(
      CreateUserViewModel model, BuildContext context) async {
    await model.createUser(context);
    if (await model.isLoggedIn()) {
      Navigator.pop(context);
      if (_registrationType ==
          LocationMapPage.REGISTRATION_TYPE_EDIT_MAIN_ADDRESS) {
        ExtendedNavigator.rootNavigator.pop(1);
      } else {
        ExtendedNavigator.rootNavigator.pop();
        ExtendedNavigator.rootNavigator
            .pushReplacementNamed(Routes.navigationPage);
      }
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('error_occurred').tr(),
      ));
    }

    return Future.value();
  }

  ///if user selects to register the sub contact address details execute this method
  Future<void> _registerSubAddress(
      CreateUserViewModel model, BuildContext context) async {
    ContactsRequestAPI api;
    if (_registrationType == LocationMapPage.REGISTRATION_TYPE_SUB_ADDRESS) {
      api = await model.createNewContact(context);
    } else {
      api = await model.updateExistingContact(context);
    }

    Navigator.pop(context);
    if (api != null) {
      ExtendedNavigator.rootNavigator.pop(1);
      print("Contact Creation 01");
      this.onContactCreated(api.contactID);
    } else {
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text('error_occurred').tr(),
      ));
    }

    return Future.value();
  }

  ///get current user details from the DB
  Future<void> _loadUserDetails(CreateUserViewModel model) async {
    await UserAuth().renewUser();
    UserAuth().getCurrentUser().then((user) {
      if (user == null || user.toMap() == null || user.toMap().isEmpty) return;

      _loadCityDetails(user.cityId, model); //load city and district
      setState(() {
        _currentUser = user;
        List<String> value = user.name.split(" ");
        model.firstName.text = (value.isInvalid()) ? '' : value[0];
        model.lastName.text =
            (value.isInvalid() || value.length < 2) ? '' : value[1];

        model.nic.text = user.nic ?? '';
        model.mainRoad.text = user.mainRoad ?? '';
        model.street.text = user.street ?? '';
        model.houseNo.text = user.houseNo ?? '';
        model.landMarks.text =
            user.landMarks.isInvalid() ? '' : user.landMarks.join(',');
      });
      print('nmj current user data ${_currentUser.toMap()}');
    }, onError: (e) => print(e)).catchError((e) => print(e));
  }

  ///get given contact details from the DB
  Future<void> _loadContactDetails(CreateUserViewModel model) async {
    ContactEntity contact = await ContactDAO()
        .getMatchingEntry(ContactEntity(), where: '_id = "$_contactID"');
    if (contact == null || contact.toMap() == null || contact.toMap().isEmpty)
      return;

    _loadCityDetails(contact.cityId, model); //load city and district
    setState(() {
      List<String> value = contact.name.split(" ");
      model.firstName.text = (value.isInvalid()) ? '' : value[0];
      model.lastName.text =
          (value.isInvalid() || value.length < 2) ? '' : value[1];

      model.nic.text = contact.nicNumber ?? '';
      model.mainRoad.text = contact.mainRoad ?? '';
      model.street.text = contact.street ?? '';
      model.houseNo.text = contact.houseNo ?? '';
      model.landMarks.text =
          contact.landmarks.isInvalid() ? '' : contact.landmarks.join(',');
      model.contactID = contact.contactID;
    });
  }

  ///get district and city details according to the given city id
  Future<void> _loadCityDetails(
      String cityID, CreateUserViewModel model) async {
    try {
      CityEntity cityEntity = await CityDAO()
          .getMatchingEntry(CityEntity(), where: 'cityID = "$cityID"');
      if (cityEntity == null) return Future.value();

      DistrictEntity districtEntity = await DistrictDAO().getMatchingEntry(
          DistrictEntity(),
          where: 'ID = "${cityEntity.districtId}"');
      if (districtEntity == null) return Future.value();

      String district =
          await LanguageHelper(names: districtEntity.districtName).getName();
      String city = await LanguageHelper(names: cityEntity.name).getName();

      setState(() {
        model.cityID = cityEntity.cityID;
        model.districtId = districtEntity.ID;

        model.city.value.text = city;
        model.district.value.text = district;
      });
    } catch (e) {
      print(e);
    }
    return Future.value();
  }
}

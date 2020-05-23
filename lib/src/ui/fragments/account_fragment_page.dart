import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/const/language_constants.dart';
import 'package:food_deliver/src/db/dao/city_dao.dart';
import 'package:food_deliver/src/db/dao/district_dao.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/city_entity.dart';
import 'package:food_deliver/src/db/entity/districts_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/ui/pages/registration/location_map_page.dart';
import 'package:food_deliver/src/routes/router.gr.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/utills/language_helper.dart';
import 'package:food_deliver/src/utills/localization_helper.dart';
import 'package:food_deliver/src/utills/user_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class AccountFragmentPage extends StatefulWidget {
  final Function onCartCleared;

  AccountFragmentPage({
    Key key,
    @required this.onCartCleared,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountFragmentPageState();
  }
}

class _AccountFragmentPageState extends State<AccountFragmentPage> {
  UserEntity _currentUser;

  @override
  void initState() {
    _loadUserDetails(); //load current user details
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 5, 16),
              child: Container(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Material(
                  color: AppColors.BACK_WHITE_COLOR,
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  color: AppColors.LIGHTER_TEXT_COLOR,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      'my_info',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.DARK_TEXT_COLOR),
                                    ).tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ).tr(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                          child: Divider(
                            color: AppColors.LIGHT_TEXT_COLOR,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  child: Text(
                                    'full_name',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.DARK_TEXT_COLOR),
                                  ).tr(),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                ),
                              ),
                              Padding(
                                child: Text(
                                  (_currentUser != null)
                                      ? (_currentUser.name ?? '')
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                              ),
                            ],
                          ),
                        ),
//                        Padding(
//                          padding: const EdgeInsets.fromLTRB(8, 5, 16, 0),
//                          child: Row(
//                            children: <Widget>[
//                              Expanded(
//                                child: Padding(
//                                  child: Text(
//                                    'nic_no',
//                                    style: TextStyle(
//                                        fontSize: 15.0,
//                                        fontWeight: FontWeight.bold,
//                                        color: AppColors.DARK_TEXT_COLOR),
//                                  ).tr(),
//                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
//                                ),
//                              ),
//                              Padding(
//                                child: Text(
//                                  (_currentUser != null)
//                                      ? (_currentUser.nic ?? '')
//                                      : '',
//                                  style: TextStyle(
//                                      fontSize: 15.0,
//                                      color: AppColors.DARK_TEXT_COLOR),
//                                ),
//                                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
//                              ),
//                            ],
//                          ),
//                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  child: Text(
                                    'contact_no',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: AppColors.DARK_TEXT_COLOR),
                                  ).tr(),
                                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                ),
                              ),
                              Padding(
                                child: Text(
                                  (_currentUser != null)
                                      ? (_currentUser.mobileNumber ?? '')
                                      : '',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
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
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ).tr(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                          child: Divider(
                            color: AppColors.LIGHT_TEXT_COLOR,
                            height: 1,
                          ),
                        ),
                        Row(children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
//                            child: Icon(Icons.location_on),
//                          ),
                          Expanded(
                            child: Container(
                              height: 70,
                              child: Padding(
                                child: Text(
                                  (_currentUser != null)
                                      ? (_currentUser.street + "" ?? '')
                                      : '',
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ),
                                padding: EdgeInsets.fromLTRB(12, 16, 12, 12),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 16, 15, 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                OutlineButton.icon(
                                  onPressed: () {
                                    ExtendedNavigator.of(context).pushNamed(
                                        Routes.locationRegisterPage,
                                        arguments: LocationRegisterPageArguments(
                                          onSave: (){
                                            // reload data
                                            _loadUserDetails();
                                          },
                                            registrationType: LocationMapPage
                                                .REGISTRATION_TYPE_EDIT_MAIN_ADDRESS));
                                  },
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit'),
                                  padding: EdgeInsets.fromLTRB(24, 0, 32, 0),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
            child: Text(
              'language',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.DARK_TEXT_COLOR),
            ).tr(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Divider(
              color: AppColors.LIGHT_TEXT_COLOR,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 14, 5, 0),
            child: Center(
              child: Row(
//                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          height: 120,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Material(
                                color: (_currentUser != null &&
                                        !_currentUser.language.isInvalid() &&
                                        _currentUser.language.equals(
                                            LanguageConstants
                                                .LANGUAGE_CONSTANTS_ENGLISH))
                                    ? AppColors.LIGHT_MAIN_COLOR
                                    : AppColors.BACK_WHITE_COLOR,
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(16.0),
                                child: FlatButton(
                                  onPressed: () {
                                    _updateLanguage(
                                        language: LanguageConstants
                                            .LANGUAGE_CONSTANTS_ENGLISH,
                                        context: context);
                                  },
                                  child: Center(
                                    child: Text(
                                      "English",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.DARK_TEXT_COLOR),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Material(
                            color: (_currentUser != null &&
                                    !_currentUser.language.isInvalid() &&
                                    _currentUser.language.equals(LanguageConstants
                                        .LANGUAGE_CONSTANTS_SINHALA))
                                ? AppColors.LIGHT_MAIN_COLOR
                                : AppColors.BACK_WHITE_COLOR,
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(16.0),
                            child: FlatButton(
                              onPressed: () {
                                _updateLanguage(
                                    language: LanguageConstants
                                        .LANGUAGE_CONSTANTS_SINHALA,
                                    context: context);
                              },
                              child: Center(
                                child: Text(
                                  "සිංහල",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.DARK_TEXT_COLOR),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          height: 120,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Material(
                                color: (_currentUser != null &&
                                        !_currentUser.language.isInvalid() &&
                                        _currentUser.language.equals(
                                            LanguageConstants
                                                .LANGUAGE_CONSTANTS_TAMIL))
                                    ? AppColors.LIGHT_MAIN_COLOR
                                    : AppColors.BACK_WHITE_COLOR,
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(16.0),
                                child: FlatButton(
                                  onPressed: () {
                                    _updateLanguage(
                                        language: LanguageConstants
                                            .LANGUAGE_CONSTANTS_TAMIL,
                                        context: context);
                                  },
                                  child: Center(
                                    child: Text(
                                      "தமிழ்",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "MuktaMalar",
                                          color: AppColors.DARK_TEXT_COLOR),
                                    ),
                                  ),
                                )),
                          )),
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 0, 0),
            child: Text(
              'locations',
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.DARK_TEXT_COLOR),
            ).tr(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Divider(
              color: AppColors.DIVIDER_COLOR,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
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
                        ExtendedNavigator.of(context)
                            .pushNamed(Routes.manageLocationsPage, arguments:
                                ManageLocationsPageArguments(onCartCleared: () {
                          widget.onCartCleared();
                        }));
                      },
                      child: Text(
                        'Manage_locations',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            color: AppColors.MAIN_COLOR),
                      ).tr(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///get current user details from the DB
  Future<void> _loadUserDetails() async {
    try {
      await UserAuth().renewUser();
      UserAuth().getCurrentUser().then((user) {
        if (user == null || user.toMap() == null || user.toMap().isEmpty)
          return;

        _loadCityDetails(user.cityId); //get city details

        setState(() {
          _currentUser = user;
        });
      }, onError: (e) => print(e)).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
    return Future.value();
  }

  ///get district and city details according to the given city id
  Future<void> _loadCityDetails(String cityID) async {
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
        _currentUser.districtName = district;
        _currentUser.cityName = city;
      });
    } catch (e) {
      print(e);
    }
    return Future.value();
  }

  ///update language in local DB
  void _updateLanguage({String language, BuildContext context}) async {
    if (_currentUser != null) {
      setState(() {
        _currentUser.language = language;
      });

      UserDAO userDAO = UserDAO();
      bool success = await userDAO.updateData(_currentUser,
          where: 'ID=?', whereArgs: [_currentUser.ID]);

      if (success) {
        LocalizationHelper.setLocalization(context, language);
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Language successfully updated.'),
        ));
        return;
      }
    }

    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Language update failed.'),
    ));
  }
}

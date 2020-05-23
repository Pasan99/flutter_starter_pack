import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_deliver/src/const/language_constants.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/utills/localization_helper.dart';
import 'package:food_deliver/src/values/colors.dart';
import 'package:food_deliver/src/viewmodels/create_user_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../routes/router.gr.dart';

class PickLanguagePage extends StatefulWidget {


  PickLanguagePage({Key key}) : super(key: key);
  @override
  _PickLanguagePageState createState() => _PickLanguagePageState();
}

class _PickLanguagePageState extends State<PickLanguagePage> {
  String _selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ChangeNotifierProvider(
        create: (context) => CreateUserViewModel(),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: AppColors.BACK_WHITE_COLOR,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/images/language_illustration.png",),
                              Container(height: 10,),
                              Consumer<CreateUserViewModel>(
                                builder: (context, model, child) {
                                  return MaterialButton(
                                    height: 60,
                                    splashColor: AppColors.LIGHT_MAIN_COLOR,
                                    highlightColor: AppColors.LIGHT_MAIN_COLOR,
                                    focusColor: AppColors.LIGHT_MAIN_COLOR,
                                    minWidth: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      'English',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 25,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        side: BorderSide(color: AppColors.MAIN_COLOR)),
                                    color: (!_selectedLanguage.isInvalid() &&
                                            _selectedLanguage.equals(LanguageConstants
                                                .LANGUAGE_CONSTANTS_ENGLISH))
                                        ? Colors.amber[400]
                                        : Colors.white,
                                    onPressed: () async {
                                      setState(() {
                                        this._selectedLanguage =
                                            LanguageConstants.LANGUAGE_CONSTANTS_ENGLISH;
                                      });

                                      //save language in local DB
                                      _saveLanguage(
                                          language: LanguageConstants
                                              .LANGUAGE_CONSTANTS_ENGLISH,
                                          context: context);
                                    },
                                    elevation: 0,
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              Consumer<CreateUserViewModel>(
                                builder: (context, model, child) {
                                  return MaterialButton(
                                    height: 60,
                                    splashColor: AppColors.LIGHT_MAIN_COLOR,
                                    highlightColor: AppColors.LIGHT_MAIN_COLOR,
                                    focusColor: AppColors.LIGHT_MAIN_COLOR,
                                    minWidth: MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      'සිංහල',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'AbhayaLibre',
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(25.0),
                                        side: BorderSide(color: AppColors.MAIN_COLOR)),
                                    color: (!_selectedLanguage.isInvalid() &&
                                            _selectedLanguage.equals(LanguageConstants
                                                .LANGUAGE_CONSTANTS_SINHALA))
                                        ? Colors.amber[400]
                                        : Colors.white,
                                    onPressed: () async {
                                      setState(() {
                                        this._selectedLanguage =
                                            LanguageConstants.LANGUAGE_CONSTANTS_SINHALA;
                                      });

                                      //save language in local DB
                                      _saveLanguage(
                                          language: LanguageConstants
                                              .LANGUAGE_CONSTANTS_SINHALA,
                                          context: context);
                                    },
                                    elevation: 0,
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                              Consumer<CreateUserViewModel>(
                                builder: (context, model, child) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: MaterialButton(
                                      height: 60,
                                      splashColor: AppColors.LIGHT_MAIN_COLOR,
                                      highlightColor: AppColors.LIGHT_MAIN_COLOR,
                                      focusColor: AppColors.LIGHT_MAIN_COLOR,
                                      minWidth: MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        'தமிழ்',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 25,
                                          fontFamily: 'MuktaMalar',
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          side: BorderSide(color: AppColors.MAIN_COLOR)),
                                      color: (!_selectedLanguage.isInvalid() &&
                                              _selectedLanguage.equals(LanguageConstants
                                                  .LANGUAGE_CONSTANTS_TAMIL))
                                          ? Colors.amber[400]
                                          : Colors.white,
                                      onPressed: () async {
                                        setState(() {
                                          this._selectedLanguage =
                                              LanguageConstants.LANGUAGE_CONSTANTS_TAMIL;
                                        });

                                        //save language in local DB
                                        _saveLanguage(
                                            language:
                                                LanguageConstants.LANGUAGE_CONSTANTS_TAMIL,
                                            context: context);
                                      },
                                      elevation: 0,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Powered by Rumex"),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///save language in local DB and move to next screen
  void _saveLanguage({String language, BuildContext context}) async {
    LocalizationHelper.setLocalization(context, language);
    UserEntity user = UserEntity();
    user.language = language;

    UserDAO userDAO = UserDAO();
    int success = await userDAO.insertData(user);

    if (success > 0) {
      ExtendedNavigator.rootNavigator
          .pushReplacementNamed(Routes.phoneNumberRegisterPage);
//      Navigator.pushReplacement(context,
//          MaterialPageRoute(builder: (context) => PhoneNumberRegisterPage()));
    }
  }
}

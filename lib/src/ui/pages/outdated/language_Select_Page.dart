import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/values/colors.dart';
import '../../../routes/router.gr.dart';

import 'package:auto_route/auto_route.dart';
import 'package:food_deliver/src/api/models/request/user_requset_api.dart';
import 'package:food_deliver/src/db/db_controller.dart';
import 'package:food_deliver/src/db/entity/cart_item_entity.dart';
import 'package:food_deliver/src/db/entity/package_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/viewmodels/create_user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class Language_select_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Language_select_Body(),
    );
  }
}

class Language_select_Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ChangeNotifierProvider(
          create: (context) => CreateUserViewModel(),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
              child: Center(
                  child: Column(
                children: <Widget>[
                  Container(
                    width: 160,
                    height: 160,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                      child: Material(
                        color: AppColors.BACK_WHITE_COLOR,
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(16.0),
                        child: Consumer<CreateUserViewModel>(
                            builder: (context, model, child) {
                          return FlatButton(
                            onPressed: () async {
                              UserEntity userEntity = UserEntity();
                              userEntity.language = "english";
                              await model.saveLanguageInLocalDb(userEntity);

                                      EasyLocalization
                                          .of(context)
                                          .locale =
                                      EasyLocalization
                                          .of(context)
                                          .supportedLocales[0];
                                      ExtendedNavigator.of(context)
                                          .pushNamed(
                                          Routes.phoneNumberRegisterPage);
//    addLanguage(language: "english", context: context);


                            },
                            child: Center(
                              child: Text(
                                "English",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.DARK_TEXT_COLOR),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Container(
                      width: 160,
                      height: 160,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Material(
                          color: AppColors.BACK_WHITE_COLOR,
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Consumer<CreateUserViewModel>(
                              builder: (context, model, child) {
                            return FlatButton(
                              onPressed: () async {
                                UserEntity userEntity = UserEntity();
                                userEntity.language = "sinhala";
                                await model.saveLanguageInLocalDb(userEntity);
                                EasyLocalization.of(context).locale =
                                    EasyLocalization.of(context)
                                        .supportedLocales[1];
                                ExtendedNavigator.of(context)
                                    .pushNamed(Routes.phoneNumberRegisterPage);

//    addLanguage(language: "sinhala", context: context);
                              },
                              child: Center(
                                child: Text(
                                  "සිංහල",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'AbhayaLibre',
                                      color:AppColors.DARK_TEXT_COLOR),
                                ),
                              ),
                            );
                          }),
                        ),
                      )),
                  Container(
                      width: 160,
                      height: 160,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Material(
                            color: AppColors.BACK_WHITE_COLOR,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(16.0),
                            child: Consumer<CreateUserViewModel>(
                                builder: (context, model, child) {
                              return FlatButton(
                                onPressed: () async {
                                  UserEntity userEntity = UserEntity();
                                  userEntity.language = "tamil";
                                  await model.saveLanguageInLocalDb(userEntity);
                                  EasyLocalization.of(context).locale =
                                      EasyLocalization.of(context)
                                          .supportedLocales[2];
                                  ExtendedNavigator.of(context).pushNamed(
                                      Routes.phoneNumberRegisterPage);
//    addLanguage(language: "tamil", context: context);
                                },
                                child: Center(
                                  child: Text(
                                    "தமிழ்",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'MuktaMalar',
                                        color: AppColors.DARK_TEXT_COLOR),
                                  ),
                                ),
                              );
                            })),
                      )),
                ],
              )))),
    );
  }

  addLanguage({String language, BuildContext context}) async {
    UserEntity user = UserEntity();
    user.language = language;

    UserDAO userDAO = UserDAO();
    int success = await userDAO.insertData(user);

    if (success > 0) {
      ExtendedNavigator.of(context).pop();
      ExtendedNavigator.of(context).pushNamed(Routes.phoneNumberRegisterPage);
    }
  }
}

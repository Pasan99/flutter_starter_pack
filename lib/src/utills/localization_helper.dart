
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/const/language_constants.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class LocalizationHelper {
  static setLocalization(BuildContext context, String language) {
    switch (language) {
      case LanguageConstants.LANGUAGE_CONSTANTS_ENGLISH:
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales[0];
        break;
      case LanguageConstants.LANGUAGE_CONSTANTS_SINHALA:
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales[1];
        break;
      case LanguageConstants.LANGUAGE_CONSTANTS_TAMIL:
        EasyLocalization.of(context).locale =
            EasyLocalization.of(context).supportedLocales[2];
        break;
    }
  }
  static updateLanguage(BuildContext context) async {
    UserEntity user = await UserAuth().getCurrentUser();
    if (user.language != null) {
      setLocalization(context, user.language);
    }
  }
}

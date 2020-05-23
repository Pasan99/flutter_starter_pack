import 'package:flutter/cupertino.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';
import 'package:food_deliver/src/ext/string_extension.dart';
import 'package:food_deliver/src/utills/user_auth.dart';

class LanguageHelper {
  Map<String, dynamic> names;

  LanguageHelper({@required this.names});

  Future<String> getName() async {
    try {
      UserEntity currentUser = await UserAuth().getCurrentUser();
      if (names == null) {
        return "Unknown";
      }

      String name = names[currentUser.language.toLowerCase()];
      if (name.isInvalid()) name = names['english'];

      return name.isInvalid() ? "Name is Invalid" : name;
    } catch (e) {
      print(e);
    }

    return Future.value("Unknown");
  }
}

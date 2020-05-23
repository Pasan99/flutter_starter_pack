import 'package:food_deliver/src/db/dao/contact_dao.dart';
import 'package:food_deliver/src/db/dao/user_dao.dart';
import 'package:food_deliver/src/db/entity/contact_entity.dart';
import 'package:food_deliver/src/db/entity/user_entity.dart';

class UserAuth {
  static final _instance = UserAuth._internal();
  UserEntity _currentUser;


  factory UserAuth() {
    return _instance;
  }

  UserAuth._internal();

  ///get the existing DB connection or create a new one
  Future<UserEntity> getCurrentUser() async {
    if (_currentUser == null) {
      await _getUser();
      return Future.value(_currentUser);
    } else {
      return Future.value(_currentUser);
    }
  }

  Future<bool> renewUser() async {
    return Future.value(await _getUser());
  }

  Future<ContactEntity> getSelectedContact() async {
    _currentUser = await getCurrentUser();
    ContactDAO dao = ContactDAO();
    ContactEntity contact = ContactEntity();
    contact = await dao.getMatchingEntry(contact, where: "_id = '${_currentUser.selectedContactId}'");
    return contact;
  }

  Future<bool> _getUser() async {
    UserDAO dao = UserDAO();
    _currentUser = UserEntity();
    _currentUser = await dao.getMatchingEntry(_currentUser, where: "language IS NOT NULL");
    if (_currentUser != null){
      // find whether he also entered the phone number
      UserEntity user = await dao.getMatchingEntry(_currentUser, where: "mobileNumber IS NOT NULL AND language IS NOT NULL");
      if (user != null){
        _currentUser = user;
        // find whether he also registered
        UserEntity registeredUser = await dao.getMatchingEntry(_currentUser, where: "authId IS NOT NULL AND mobileNumber IS NOT NULL AND language IS NOT NULL AND accessToken IS NOT NULL");
        if (registeredUser != null){
          _currentUser = registeredUser;
        }
      }
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    await renewUser();
    if (_currentUser.accessToken == null){
      return false;
    }
    return true;
  }

  Future<bool> setSelectedContact({String contactId}) async {
    UserDAO dao = UserDAO();
    _currentUser.selectedContactId = contactId;
    bool isSuccess = await dao.updateData(_currentUser, where: "authId = '${_currentUser.authId}'");
    if (isSuccess){
      return true;
    }
    return false;
  }

}
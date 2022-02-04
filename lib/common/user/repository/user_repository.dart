import 'dart:async';


import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/user/model/user.dart';

class UserRepository {
  User _user;
  LocalDataHelper localDataHelper  = LocalDataHelper();

  Future<User> getUser() async {
    if (_user != null) return _user;
     var token = await localDataHelper.getStringValue(key: TOKEN);
    return Future.delayed(
      const Duration(milliseconds: 300),
     
      () => _user = User(token),
    );
  }
}

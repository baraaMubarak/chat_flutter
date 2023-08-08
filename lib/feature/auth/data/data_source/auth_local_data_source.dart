import 'dart:convert';

import 'package:chat/core/shared_pref/shared_pref.dart';
import 'package:chat/feature/auth/data/model/user.dart';
import 'package:chat/feature/auth/domain/entities/User.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveUser(User user);

  String? getToken();
  User? getUser();
}

class AuthLocalDataSourceImp implements AuthLocalDataSource {
  SharedPrefController sharedPrefController = SharedPrefController();

  AuthLocalDataSourceImp();

  final String TOKEN = 'TOKEN';
  final String USER = 'USER';

  @override
  String? getToken() {
    return sharedPrefController.get(key: TOKEN);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPrefController.save(key: TOKEN, value: token);
  }

  @override
  User? getUser() {
    return UserModel.fromJson(jsonDecode(sharedPrefController.get(key: USER)));
  }

  @override
  Future<void> saveUser(User user) async {
    await sharedPrefController.save(key: TOKEN, value: jsonEncode(UserModel(user).toJson()));
  }
}

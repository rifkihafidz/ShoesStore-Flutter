import 'package:flutter/cupertino.dart';
import 'package:shamo_frontend/models/user_model.dart';
import 'package:shamo_frontend/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().register(
        name: name,
        username: username,
        email: email,
        password: password,
      );

      _user = user;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );

      _user = user;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await AuthService().logout();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String username,
  }) async {
    try {
      UserModel user = await AuthService().updateProfile(
        name: name,
        email: email,
        username: username,
      );

      _user = user;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

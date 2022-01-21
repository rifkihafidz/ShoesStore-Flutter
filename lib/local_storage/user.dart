import 'package:get_storage/get_storage.dart';
import 'package:shamo_frontend/models/user_model.dart';

class LocalStorage {
  final _storage = GetStorage();

  // Save User Data Locally
  Future<void> saveUserData(UserModel user) {
    try {
      print('User Data Saved');
      return _storage.write('localUserData', user.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get User Data from Local Storage
  UserModel getUserData() {
    try {
      final Map<String, dynamic> _readStorage = _storage.read('localUserData');
      UserModel _result = UserModel.fromJson(_readStorage);
      print('User Logged In');
      return _result;
    } catch (e) {
      throw Exception('User Not Logged In.');
    }
  }

  void deleteUserData() {
    try {
      _storage.remove('localUserData');
      print('User Logged Out');
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';

import 'package:shamo_frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shamo_frontend/storage/keystore.dart';

class AuthService {
  // String baseUrl = 'https://shamo-backend.buildwithangga.id/api';
  String baseUrl = 'http://10.0.2.2:8000/api';

  Future<UserModel> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];
      await Keystore.save('token', data['access_token']);

      return user;
    } else {
      throw Exception('Registration failed.');
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];
      await Keystore.save('token', data['access_token']);

      return user;
    } else {
      throw Exception('Login failed.');
    }
  }

  Future<bool> logout() async {
    var url = Uri.parse('$baseUrl/logout');
    String token = await Keystore.read('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    };
    var response = await http.post(url, headers: headers);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      await Keystore.delete('token');
      return true;
    } else {
      throw Exception('Failed to Logout.');
    }
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    required String username,
  }) async {
    var url = '$baseUrl/user';
    String token = await Keystore.read('token');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token,
    };
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
    });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      UserModel user = UserModel.fromJson(jsonDecode(response.body)['data']);

      return user;
    } else {
      throw Exception('Failed to Update Data');
    }
  }
}

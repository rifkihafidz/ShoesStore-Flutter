import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Keystore {
  static final storage = new FlutterSecureStorage();

  static Future save(String key, String data) async {
    await storage.write(key: key, value: data);
  }

  static Future read(String key) async {
    return await storage.read(key: key);
  }

  static Future delete(String key) async {
    await storage.delete(key: key);
  }
}

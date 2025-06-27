import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  const Storage();

  static late final SharedPreferences instance;

  static init() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<bool> setItem(String key, dynamic value) async {
    try {
      if (value == null) {
        return instance.remove(key);
      } else {
        String keyValue = jsonEncode(value);
        return instance.setString(key, keyValue);
      }
    } catch (error) {
      return false;
    }
  }

  static getItem(String key) {
    final result = instance.getString(key);

    return result == null ? null : jsonDecode(result);
  }

  static remove(String key) async {
    try {
      return instance.remove(key);
    } catch (error) {
      return false;
    }
  }

  static clear() async {
    try {
      return instance.clear();
    } catch (error) {
      return false;
    }
  }
}

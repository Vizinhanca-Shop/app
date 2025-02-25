import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorageService {
  Future<void> saveMap(String key, Map<String, dynamic> map);
  Future<Map<String, dynamic>?> loadMap(String key);
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<bool> remove(String key);
}

class LocalStorageServiceImpl implements LocalStorageService {
  @override
  Future<void> saveMap(String key, Map<String, dynamic> map) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(map));
  }

  @override
  Future<Map<String, dynamic>?> loadMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    } else {
      return null;
    }
  }

  @override
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

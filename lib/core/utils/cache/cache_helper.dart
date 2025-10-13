import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static CacheHelper? _instance;
  final SharedPreferences _prefs;

  // Private constructor
  CacheHelper._internal(this._prefs);

  @visibleForTesting
  static void reset() {
    _instance = null;
  }

  // Factory constructor for testing - accepts SharedPreferences instance
  @visibleForTesting
  static CacheHelper createForTest(SharedPreferences prefs) {
    _instance = CacheHelper._internal(prefs);
    return _instance!;
  }

  // Static getter for the singleton instance
  static CacheHelper get instance {
    if (_instance == null) {
      throw StateError(
          'CacheHelper must be initialized with CacheHelper.initialize() first');
    }
    return _instance!;
  }

  // Initialize the singleton
  static Future<void> initialize() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = CacheHelper._internal(prefs);
    }
  }

  // Check if initialized
  static bool get isInitialized => _instance != null;

  // Your methods
  String? getDataString({required String key}) {
    return _prefs.getString(key);
  }

  Future<bool> saveData({required String key, required dynamic value}) async {
    try {
      if (value is bool) return await _prefs.setBool(key, value);
      if (value is String) return await _prefs.setString(key, value);
      if (value is int) return await _prefs.setInt(key, value);
      if (value is double) return await _prefs.setDouble(key, value);
      return false;
    } catch (e) {
      debugPrint('CacheHelper.saveData error: $e');
      return false;
    }
  }

  dynamic getData({required String key}) {
    return _prefs.get(key);
  }

  Future<bool> removeData({required String key}) async {
    return _prefs.remove(key);
  }

  bool containsKey({required String key}) {
    return _prefs.containsKey(key);
  }

  Future<bool> clearData() async {
    return _prefs.clear();
  }
}

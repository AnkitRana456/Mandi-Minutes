import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive key-value pairs.
class PreferencesStorageService {
  final SharedPreferences _prefs;

  PreferencesStorageService(this._prefs);

  static Future<PreferencesStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesStorageService(prefs);
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}

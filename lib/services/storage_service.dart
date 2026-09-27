import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for persistent local storage.
class StorageService {
  StorageService._(this._prefs);

  final SharedPreferences _prefs;

  static StorageService? _instance;
  static Future<StorageService> get instance async {
    _instance ??= StorageService._(await SharedPreferences.getInstance());
    return _instance!;
  }

  // Keys
  static const _kOnboardingSeen = 'onboarding_seen';
  static const _kUser = 'user_data';
  static const _kToken = 'auth_token';
  static const _kTransactions = 'transactions';
  static const _kDarkMode = 'dark_mode';

  bool get onboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen(bool value) => _prefs.setBool(_kOnboardingSeen, value);

  String? get token => _prefs.getString(_kToken);
  Future<void> setToken(String value) => _prefs.setString(_kToken, value);
  Future<void> clearToken() => _prefs.remove(_kToken);

  Map<String, dynamic>? get user {
    final raw = _prefs.getString(_kUser);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(Map<String, dynamic> value) =>
      _prefs.setString(_kUser, jsonEncode(value));

  List<Map<String, dynamic>> get transactions {
    final raw = _prefs.getStringList(_kTransactions) ?? [];
    return raw
        .map((e) {
          try {
            return jsonDecode(e) as Map<String, dynamic>;
          } catch (_) {
            return <String, dynamic>{};
          }
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> saveTransactions(List<Map<String, dynamic>> value) {
    final encoded = value.map(jsonEncode).toList();
    return _prefs.setStringList(_kTransactions, encoded);
  }

  bool get darkMode => _prefs.getBool(_kDarkMode) ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_kDarkMode, value);

  List<Map<String, dynamic>> getList(String key) {
    final raw = _prefs.getStringList(key) ?? [];
    return raw
        .map((e) {
          try {
            return jsonDecode(e) as Map<String, dynamic>;
          } catch (_) {
            return <String, dynamic>{};
          }
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> setList(String key, List<Map<String, dynamic>> value) {
    final encoded = value.map(jsonEncode).toList();
    return _prefs.setStringList(key, encoded);
  }

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();
}

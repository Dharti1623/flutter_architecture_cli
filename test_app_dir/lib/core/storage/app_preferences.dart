import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app_dir/core/constants/shared_pref_keys.dart';
import 'package:test_app_dir/core/storage/storage_service.dart';

class AppPreferences implements StorageService {
  static final AppPreferences _instance = AppPreferences._internal();
  SharedPreferences? _prefs;

  factory AppPreferences() => _instance;

  AppPreferences._internal();

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Type-safe Getters & Setters for SharedPrefKeys

  Future<void> setToken(String value) async =>
      await setString(SharedPrefKeys.token, value);
  String? get token => getString(SharedPrefKeys.token);

  Future<void> setRefreshToken(String value) async =>
      await setString(SharedPrefKeys.refreshToken, value);
  String? get refreshToken => getString(SharedPrefKeys.refreshToken);

  Future<void> setUserId(String value) async =>
      await setString(SharedPrefKeys.userId, value);
  String? get userId => getString(SharedPrefKeys.userId);

  Future<void> setUserData(String value) async =>
      await setString(SharedPrefKeys.userData, value);
  String? get userData => getString(SharedPrefKeys.userData);

  Future<void> setLanguageCode(String value) async =>
      await setString(SharedPrefKeys.languageCode, value);
  String? get languageCode => getString(SharedPrefKeys.languageCode);

  Future<void> setThemeMode(String value) async =>
      await setString(SharedPrefKeys.themeMode, value);
  String? get themeMode => getString(SharedPrefKeys.themeMode);

  Future<void> setIsLoggedIn(bool value) async =>
      await setBool(SharedPrefKeys.isLoggedIn, value);
  bool? get isLoggedIn => getBool(SharedPrefKeys.isLoggedIn);

  Future<void> setOnboardingCompleted(bool value) async =>
      await setBool(SharedPrefKeys.onboardingCompleted, value);
  bool? get onboardingCompleted => getBool(SharedPrefKeys.onboardingCompleted);

  // Generic Operations

  Future<bool> setString(String key, String value) async =>
      await _prefs!.setString(key, value);
  String? getString(String key) => _prefs?.getString(key);

  Future<bool> setBool(String key, bool value) async =>
      await _prefs!.setBool(key, value);
  bool? getBool(String key) => _prefs?.getBool(key);

  Future<bool> setInt(String key, int value) async =>
      await _prefs!.setInt(key, value);
  int? getInt(String key) => _prefs?.getInt(key);

  Future<bool> setDouble(String key, double value) async =>
      await _prefs!.setDouble(key, value);
  double? getDouble(String key) => _prefs?.getDouble(key);

  Future<bool> remove(String key) async => await _prefs!.remove(key);

  @override
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}

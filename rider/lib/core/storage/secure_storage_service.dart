import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.keyToken);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.keyToken);
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: AppConstants.keyToken, value: token);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyToken, token);
  }

  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
  }

  Future<bool> isOnline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.keyIsOnline) ?? false;
  }

  Future<void> setOnline(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsOnline, value);
  }
}

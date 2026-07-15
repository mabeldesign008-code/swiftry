import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Secure storage abstraction - frontend ready for backend token handling.
/// Uses flutter_secure_storage for tokens, shared_preferences for non-sensitive prefs.
/// Follows best practices: tokens in secure storage, not shared prefs.

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // --- Secure keys (tokens)
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id_secure';

  // --- Token handling
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (_) {
      // Fallback to SharedPreferences if secure storage fails (e.g., emulator)
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.prefKeyUserToken);
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
      // Also save to prefs for backward compatibility with old code that reads prefs
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefKeyUserToken, token);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefKeyUserToken, token);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _keyRefreshToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: _keyRefreshToken, value: token);
    } catch (_) {}
  }

  Future<void> saveTokens(String access, String refresh) async {
    await saveToken(access);
    await saveRefreshToken(refresh);
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _keyToken);
      await _storage.delete(key: _keyRefreshToken);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyUserToken);
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    // Clear auth-related prefs only, keep onboarding etc
    await prefs.remove(AppConstants.prefKeyUserToken);
    await prefs.remove(AppConstants.prefKeyUserLoggedIn);
    await prefs.remove(AppConstants.prefKeyUserId);
    await prefs.remove(AppConstants.prefKeyUserName);
    await prefs.remove(AppConstants.prefKeyUserPhone);
    await prefs.remove(AppConstants.prefKeyUserEmail);
  }

  // --- User info (secure)
  Future<void> saveUserId(String id) async {
    try {
      await _storage.write(key: _keyUserId, value: id);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefKeyUserId, id);
  }

  Future<String?> getUserId() async {
    try {
      final secure = await _storage.read(key: _keyUserId);
      if (secure != null) return secure;
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.prefKeyUserId);
  }

  // --- Auth status (non-sensitive - can be in prefs)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefKeyUserLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefKeyUserLoggedIn, value);
  }
}

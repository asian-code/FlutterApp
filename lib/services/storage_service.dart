import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/constants.dart';

/// Service for handling secure storage operations
class StorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Singleton instance
  static final StorageService _instance = StorageService._internal();

  /// Factory constructor
  factory StorageService() {
    return _instance;
  }

  /// Private constructor
  StorageService._internal();

  /// Save JWT token
  Future<void> saveJwtToken(String token) async {
    await _storage.write(key: StorageKeys.jwtToken, value: token);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: StorageKeys.refreshToken, value: token);
  }

  /// Get JWT token
  Future<String?> getJwtToken() async {
    return await _storage.read(key: StorageKeys.jwtToken);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: StorageKeys.refreshToken);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.jwtToken),
      _storage.delete(key: StorageKeys.refreshToken),
    ]);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getJwtToken();
    return token != null;
  }

  /// Save custom value
  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get custom value
  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete custom value
  Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import '../utils/constants.dart';

/// Exception thrown when API requests fail
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Service for handling API requests
class ApiService {
  final StorageService _storageService = StorageService();

  /// Singleton instance
  static final ApiService _instance = ApiService._internal();

  /// Factory constructor
  factory ApiService() {
    return _instance;
  }

  /// Private constructor
  ApiService._internal();

  /// Helper method to get authorization headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storageService.getJwtToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      String message;
      try {
        final body = jsonDecode(response.body);
        message = body['message'] ?? 'Request failed';
      } catch (e) {
        message = 'Request failed with status: ${response.statusCode}';
      }
      throw ApiException(message, statusCode: response.statusCode);
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email.trim(),
          'password': password.trim(),
        }),
      ).timeout(
        Duration(seconds: ApiConstants.requestTimeoutSeconds),
        onTimeout: () => throw ApiException('Connection timeout. Please try again.'),
      );

      final data = _handleResponse(response);

      // Save tokens
      if (data != null && data['access_token'] != null && data['refresh_token'] != null) {
        await _storageService.saveJwtToken(data['access_token']);
        await _storageService.saveRefreshToken(data['refresh_token']);
      }

      return data;
    } catch (e) {
      if (e is ApiException) {
        throw e;
      } else {
        throw ApiException(e.toString());
      }
    }
  }

  /// Create account
  Future<Map<String, dynamic>> createAccount(String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.createAccountEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullName.trim(),
          'email': email.trim(),
          'password': password.trim(),
        }),
      ).timeout(
        Duration(seconds: ApiConstants.requestTimeoutSeconds),
        onTimeout: () => throw ApiException('Connection timeout. Please try again.'),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        throw e;
      } else {
        throw ApiException(e.toString());
      }
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse(ApiConstants.userProfileEndpoint),
        headers: headers,
      ).timeout(
        Duration(seconds: ApiConstants.requestTimeoutSeconds),
        onTimeout: () => throw ApiException('Connection timeout. Please try again.'),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        throw e;
      } else {
        throw ApiException(e.toString());
      }
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.delete(
        Uri.parse(ApiConstants.deleteAccountEndpoint),
        headers: headers,
      ).timeout(
        Duration(seconds: ApiConstants.requestTimeoutSeconds),
        onTimeout: () => throw ApiException('Connection timeout. Please try again.'),
      );

      _handleResponse(response);

      // Clear tokens on success
      await _storageService.clearTokens();
    } catch (e) {
      if (e is ApiException) {
        throw e;
      } else {
        throw ApiException(e.toString());
      }
    }
  }

  /// Check if token is valid
  Future<bool> validateToken() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse(ApiConstants.userProfileEndpoint),
        headers: headers,
      ).timeout(
        Duration(seconds: ApiConstants.requestTimeoutSeconds),
        onTimeout: () => throw ApiException('Connection timeout. Please try again.'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
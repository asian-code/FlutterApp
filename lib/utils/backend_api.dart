import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.10.10.15:8000';
  static const storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<void> deleteAccount() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Authentication required. Please login again.');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/delete/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      await Future.wait([
        storage.delete(key: 'jwt_token'),
        storage.delete(key: 'refresh_token'),
      ]);
    } else {
      String errorMessage = 'Failed to delete account. Please try again.';
      if (response.statusCode == 401) {
        errorMessage = 'Session expired. Please login again.';
      }
      throw Exception(errorMessage);
    }
  }

// Add other API methods here
}
// Constants for the application
// Centralizes all constant values used throughout the app

/// API-related constants
class ApiConstants {
  // Base URL for all API endpoints
  static const String baseUrl = 'http://10.10.10.15:8000';

  // Authentication endpoints
  static const String loginEndpoint = '$baseUrl/login';
  static const String createAccountEndpoint = '$baseUrl/create';

  // User management endpoints
  static const String userProfileEndpoint = '$baseUrl/get/me';
  static const String deleteAccountEndpoint = '$baseUrl/delete/me';

  // Request timeout duration
  static const int requestTimeoutSeconds = 10;
}

/// Storage key constants
class StorageKeys {
  static const String jwtToken = 'jwt_token';
  static const String refreshToken = 'refresh_token';
}

/// Route name constants
class Routes {
  static const String login = '/';
  static const String employeeLogin = '/employee';
  static const String createAccount = '/create-account';
  static const String home = '/home';
}

/// Asset path constants
class AssetPaths {
  static const String logo = 'assets/images/Branding_big.png';
}
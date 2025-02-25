import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Repository for authentication-related operations
class AuthRepository {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  /// Singleton instance
  static final AuthRepository _instance = AuthRepository._internal();

  /// Factory constructor
  factory AuthRepository() {
    return _instance;
  }

  /// Private constructor
  AuthRepository._internal();

  /// Sign in with email and password
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    return await _apiService.login(email, password);
  }

  /// Create a new account
  Future<Map<String, dynamic>> createAccount(String fullName, String email, String password) async {
    return await _apiService.createAccount(fullName, email, password);
  }

  /// Get user profile data
  Future<Map<String, dynamic>> getUserProfile() async {
    return await _apiService.getUserProfile();
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    await _apiService.deleteAccount();
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final hasToken = await _storageService.isLoggedIn();
    if (hasToken) {
      return await _apiService.validateToken();
    }
    return false;
  }

  /// Sign out user
  Future<void> signOut() async {
    await _storageService.clearTokens();
  }
}
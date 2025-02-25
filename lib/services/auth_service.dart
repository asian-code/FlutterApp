import 'package:flutter/foundation.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Authentication service that manages user authentication state
class AuthService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;

  /// Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;

  /// Singleton instance
  static final AuthService _instance = AuthService._internal();

  /// Factory constructor
  factory AuthService() {
    return _instance;
  }

  /// Private constructor
  AuthService._internal();

  /// Initialize service and check authentication state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final hasToken = await _storageService.isLoggedIn();
      if (hasToken) {
        final isValid = await _apiService.validateToken();
        if (isValid) {
          _isAuthenticated = true;
          await _loadUserData();
        } else {
          await _storageService.clearTokens();
          _isAuthenticated = false;
        }
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user data
  Future<void> _loadUserData() async {
    try {
      _userData = await _apiService.getUserProfile();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Sign in user
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.login(email, password);
      _isAuthenticated = true;
      await _loadUserData();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new account
  Future<bool> createAccount(String fullName, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.createAccount(fullName, email, password);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _storageService.clearTokens();
      _isAuthenticated = false;
      _userData = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteAccount();
      _isAuthenticated = false;
      _userData = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
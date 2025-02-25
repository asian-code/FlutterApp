import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/create_account_screen.dart';
import 'screens/home/home_screen.dart';

/// App router that manages all routes in the application
class AppRouter {
  /// Get all routes for the app
  static Map<String, WidgetBuilder> get routes => {
    Routes.login: (context) => const LoginScreen(isEmployee: false),
    Routes.employeeLogin: (context) => const LoginScreen(isEmployee: true),
    Routes.createAccount: (context) => const CreateAccountScreen(),
    Routes.home: (context) => const HomeScreen(),
  };

  /// Navigate to the login screen, removing all previous routes
  static void navigateToLogin(BuildContext context, {bool isEmployee = false}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      isEmployee ? Routes.employeeLogin : Routes.login,
          (route) => false,
    );
  }

  /// Navigate to the create account screen
  static void navigateToCreateAccount(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.createAccount);
  }

  /// Navigate to the home screen, removing all previous routes
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.home,
          (route) => false,
    );
  }

  /// Toggle between customer and employee login
  static void toggleEmployeeMode(BuildContext context, bool isCurrentlyEmployee) {
    Navigator.of(context).pushReplacementNamed(
      isCurrentlyEmployee ? Routes.login : Routes.employeeLogin,
    );
  }
}
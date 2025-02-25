import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class AppWidgets {
  static Widget gradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: AppTheme.buttonHeight,
      decoration: AppTheme.gradientButtonDecoration,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppTheme.gradientButtonStyle,
        child: Text(text, style: AppTheme.buttonTextStyle),
      ),
    );
  }

  static Widget inputField({
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.defaultPadding),
      decoration: AppTheme.inputDecoration,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        textAlignVertical: TextAlignVertical.center,
        decoration: AppTheme.getInputDecoration(
          hint: hint,
          icon: icon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  static Widget linkButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: AppTheme.linkTextStyle),
    );
  }
}
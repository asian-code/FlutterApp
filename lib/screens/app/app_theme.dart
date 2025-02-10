import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF009688);
  static const Color secondaryColor = Color(0xFF4FC3F7);
  static const Color backgroundColor = Color(0xFF242931);
  static const Color cardColor = Color(0xFF2A2A2A);
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFF9E9E9E);
  static const Color inputBackgroundColor = Color(0xFF1A1F24);

  // Gradients
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1F24),
      Color(0xFF121417),
    ],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF4FC3F7),
      Color(0xFF009688),
    ],
  );

  // Border Radius
  static const double borderRadius = 12.0;
  // Shadows
  static final containerShadow = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 5),
  );
  // Decorations
  static BoxDecoration containerDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [containerShadow],
  );

  static BoxDecoration get appCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: Color(0x1A808080),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration get inputDecoration => BoxDecoration(
    color: inputBackgroundColor,
    borderRadius: BorderRadius.circular(borderRadius),
  );

  static BoxDecoration get gradientButtonDecoration => BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Color(0x4D009688),
        spreadRadius: 1,
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    letterSpacing: -0.5,
  );

  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textSecondaryColor),
      border: InputBorder.none,
      prefixIcon: Icon(icon, color: textSecondaryColor),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
    );
  }

  // Button Style
  static final ButtonStyle gradientButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );

  // Common Sizes
  static const double defaultPadding = 16.0;
  static const double containerPadding = 32.0;
  static const double containerWidth = 400.0;
  static const double buttonHeight = 50.0;
  static const double logoWidth = 200.0;
}

// Reusable Widgets
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
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.defaultPadding),
      decoration: AppTheme.inputDecoration,
      child: TextField(
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
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
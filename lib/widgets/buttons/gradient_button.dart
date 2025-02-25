import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
/// A button with gradient background
class GradientButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Optional loading state
  final bool isLoading;

  /// Optional custom gradient
  final Gradient? gradient;

  /// Optional custom text style
  final TextStyle? textStyle;

  /// Optional icon to display before text
  final IconData? icon;

  /// Optional padding override
  final EdgeInsetsGeometry? padding;

  /// Constructor
  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.textStyle,
    this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppTheme.buttonHeight,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.buttonGradient,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [AppTheme.buttonShadow],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.gradientButtonStyle,
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12.0),
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: AppTheme.textPrimaryColor,
              strokeWidth: 2.5,
            ),
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppTheme.textPrimaryColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle ?? AppTheme.buttonTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
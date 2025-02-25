import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A dialog for displaying warnings and confirmations
class WarningDialog extends StatelessWidget {
  /// Dialog title
  final String title;

  /// Dialog message
  final String message;

  /// Text for confirmation button
  final String confirmText;

  /// Text for cancel button
  final String cancelText;

  /// Callback when confirmation button is pressed
  final VoidCallback onConfirm;

  /// Optional callback when cancel button is pressed
  final VoidCallback? onCancel;

  /// Whether the action is destructive (e.g. delete)
  final bool isDestructive;

  /// Constructor
  const WarningDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimaryColor,  // Updated color reference
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: AppTheme.textSecondaryColor,  // Updated color reference
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancel != null) {
              onCancel!();
            }
          },
          child: Text(
            cancelText,
            style: TextStyle(
              color: AppTheme.textSecondaryColor,  // Updated color reference
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? Colors.red : AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(
            confirmText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// A helper class for showing dialogs
class DialogHelper {
  /// Show a warning dialog
  static Future<void> showWarningDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onCancel,
    bool isDestructive = true,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => WarningDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
      ),
    );
  }

  /// Show a simple error dialog
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,  // Updated color reference
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppTheme.textSecondaryColor,  // Updated color reference
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
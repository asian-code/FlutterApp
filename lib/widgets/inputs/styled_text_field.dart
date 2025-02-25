import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A styled text field with consistent formatting
class StyledTextField extends StatefulWidget {
  /// Input placeholder text
  final String hint;

  /// Icon to display at the start of the input
  final IconData icon;

  /// Whether to obscure text input (for passwords)
  final bool obscureText;

  /// Optional widget to display at the end of the input
  final Widget? suffixIcon;

  /// Optional controller for the input
  final TextEditingController? controller;

  /// Optional error message to display below input
  final String? errorText;

  /// Optional focus node
  final FocusNode? focusNode;

  /// Optional callback when text changes
  final Function(String)? onChanged;

  /// Optional text input type
  final TextInputType? keyboardType;

  /// Optional text input action
  final TextInputAction? textInputAction;

  /// Optional callback when text field is submitted
  final Function(String)? onSubmitted;

  /// Constructor
  const StyledTextField({
    Key? key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.errorText,
    this.focusNode,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<StyledTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          decoration: AppTheme.inputDecoration,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            textAlignVertical: TextAlignVertical.center,
            style: AppTheme.bodyTextStyle,
            decoration: AppTheme.getInputDecoration(
              hint: widget.hint,
              icon: widget.icon,
              suffixIcon: widget.suffixIcon,
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              widget.errorText!,
              style: AppTheme.errorTextStyle,
            ),
          ),
      ],
    );
  }
}

/// A password input field with toggle visibility button
class PasswordTextField extends StatefulWidget {
  /// Input placeholder text
  final String hint;

  /// Optional controller for the input
  final TextEditingController? controller;

  /// Optional error message to display below input
  final String? errorText;

  /// Optional focus node
  final FocusNode? focusNode;

  /// Optional callback when text changes
  final Function(String)? onChanged;

  /// Optional text input action
  final TextInputAction? textInputAction;

  /// Optional callback when text field is submitted
  final Function(String)? onSubmitted;

  /// Constructor
  const PasswordTextField({
    Key? key,
    this.hint = 'Password',
    this.controller,
    this.errorText,
    this.focusNode,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      hint: widget.hint,
      icon: Icons.lock_outline,
      controller: widget.controller,
      obscureText: _obscureText,
      errorText: widget.errorText,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppTheme.textSecondaryColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
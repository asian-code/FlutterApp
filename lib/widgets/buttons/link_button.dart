import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// A text button that resembles a hyperlink
class LinkButton extends StatelessWidget {
  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback onPressed;

  /// Optional custom text style
  final TextStyle? textStyle;

  /// Optional alignment
  final AlignmentGeometry alignment;

  /// Constructor
  const LinkButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: textStyle ?? AppTheme.linkTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
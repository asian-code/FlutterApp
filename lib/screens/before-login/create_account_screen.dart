import 'package:flutter/material.dart';
import 'login_theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Widget _buildPasswordField({
    required String hint,
    required bool isConfirmPassword,
  }) {
    bool obscureText = isConfirmPassword ? _obscureConfirmPassword : _obscurePassword;

    return AppWidgets.inputField(
      hint: hint,
      icon: Icons.lock_outline,
      obscureText: obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            if (isConfirmPassword) {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            } else {
              _obscurePassword = !_obscurePassword;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'assets/images/Branding_big.png',
                    width: AppTheme.logoWidth,
                    fit: BoxFit.contain,
                  ),
                ),
                // Create Account Container
                Container(
                  width: AppTheme.containerWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(AppTheme.containerPadding),
                  decoration: AppTheme.containerDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Account',
                        style: AppTheme.headerStyle,
                      ),
                      const SizedBox(height: 30),
                      AppWidgets.inputField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      AppWidgets.inputField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        hint: 'Password',
                        isConfirmPassword: false,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(
                        hint: 'Confirm Password',
                        isConfirmPassword: true,
                      ),
                      const SizedBox(height: 24),
                      AppWidgets.gradientButton(
                        text: 'Create Account',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: AppWidgets.linkButton(
                          text: 'Already have an account? Sign In',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
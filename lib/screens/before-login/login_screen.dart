import 'package:flutter/material.dart';
import 'package:myfirst_flutter/screens/before-login/login_theme.dart';

class LoginScreen extends StatefulWidget {
  final bool isEmployee;

  const LoginScreen({Key? key, required this.isEmployee}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  Widget _buildPasswordField() {
    return AppWidgets.inputField(
      hint: 'Password',
      icon: Icons.lock_outline,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.grey,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                // Login Container
                Container(
                  width: AppTheme.containerWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(AppTheme.containerPadding),
                  decoration: AppTheme.containerDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEmployee ? 'Employee Login' : 'Sign In',
                        style: AppTheme.headerStyle,
                      ),
                      const SizedBox(height: 30),
                      AppWidgets.inputField(
                        hint: 'Username',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      AppWidgets.linkButton(
                        text: 'Forgot Password?',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 24),
                      AppWidgets.gradientButton(
                        text: widget.isEmployee ? 'Employee Sign In' : 'Sign In',
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                      ),
                      const SizedBox(height: 16),
                      if (!widget.isEmployee)
                        Center(
                          child: AppWidgets.linkButton(
                            text: 'Not a member? Create account',
                            onPressed: () => Navigator.pushNamed(context, '/create-account'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppWidgets.linkButton(
                  text: widget.isEmployee
                      ? 'Return to Customer Login'
                      : 'Looking for Employee Portal? Click here',
                  onPressed: () => Navigator.pushNamed(
                    context,
                    widget.isEmployee ? '/' : '/employee',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
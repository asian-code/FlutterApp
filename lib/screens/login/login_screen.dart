import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  final bool isEmployee;
  const LoginScreen({Key? key, required this.isEmployee}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;
  String? _emailError;
  String? _passwordError;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Only show email error if the field has been touched
      _emailError = _emailTouched ? _validateEmail(_usernameController.text.trim()) : null;
      // Only show password error if the field has been touched
      _passwordError = _passwordTouched ? _validatePassword(_passwordController.text.trim()) : null;

      _isFormValid = _usernameController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _validateEmail(_usernameController.text.trim()) == null &&
          _validatePassword(_passwordController.text.trim()) == null;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildPasswordField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() {
            _passwordTouched = true;
            _validateForm();
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.inputField(
            hint: 'Password',
            icon: Icons.lock_outline,
            controller: _passwordController,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          if (_passwordError != null && _passwordTouched)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                _passwordError!,
                style: TextStyle(color: Colors.red[400], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          setState(() {
            _emailTouched = true;
            _validateForm();
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidgets.inputField(
            hint: 'Email',
            icon: Icons.person_outline,
            controller: _usernameController,
          ),
          if (_emailError != null && _emailTouched)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                _emailError!,
                style: TextStyle(color: Colors.red[400], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loginUser() async {
    // Validate form before proceeding
    _validateForm();
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      const String apiUrl = 'http://10.10.10.15:8000/login';

      final Map<String, String> requestBody = {
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timeout. Please try again.'),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String? jwtToken = responseData['access_token'];
        final String? refreshToken = responseData['refresh_token'];

        if (jwtToken != null && refreshToken != null) {
          const storage = FlutterSecureStorage();
          await Future.wait([
            storage.write(key: 'jwt_token', value: jwtToken),
            storage.write(key: 'refresh_token', value: refreshToken),
          ]);

          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        final errorMessage = responseData['message'] ?? 'Authentication failed';
        throw Exception(errorMessage);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    'assets/images/Branding_big.png',
                    width: AppTheme.logoWidth,
                    fit: BoxFit.contain,
                  ),
                ),
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
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      AppWidgets.linkButton(
                        text: 'Forgot Password?',
                        onPressed: () {},
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : AppWidgets.gradientButton(
                        text: widget.isEmployee ? 'Employee Sign In' : 'Sign In',
                        onPressed: _loginUser,
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
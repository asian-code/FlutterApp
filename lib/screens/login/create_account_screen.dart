import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String? _passwordError;
  String? _emailError;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }

  bool _isPasswordStrong(String password) {
    // Check for minimum length
    if (password.length < 8) {
      _passwordError = 'Password must be at least 8 characters long';
      return false;
    }

    // Check for uppercase letters
    if (!password.contains(RegExp(r'[A-Z]'))) {
      _passwordError = 'Password must contain at least one uppercase letter';
      return false;
    }

    // Check for numbers
    if (!password.contains(RegExp(r'[0-9]'))) {
      _passwordError = 'Password must contain at least one number';
      return false;
    }

    // Check for special characters
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      _passwordError = 'Password must contain at least one special character';
      return false;
    }

    _passwordError = null;
    return true;
  }

  Widget _buildPasswordField({
    required String hint,
    required bool isConfirmPassword,
  }) {
    bool obscureText = isConfirmPassword ? _obscureConfirmPassword : _obscurePassword;
    final controller = isConfirmPassword ? _confirmPasswordController : _passwordController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppWidgets.inputField(
          hint: hint,
          icon: Icons.lock_outline,
          controller: controller,
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
        ),
        if (!isConfirmPassword && _passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              _passwordError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  void _validateEmail(String email) {
    setState(() {
      if (!_isEmailValid(email)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _createAccount() async {
    // Reset errors
    setState(() {
      _passwordError = null;
      _emailError = null;
    });

    // Validate email
    if (!_isEmailValid(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Please enter a valid email address';
      });
      return;
    }

    // Validate password strength
    if (!_isPasswordStrong(_passwordController.text)) {
      return;
    }

    // Validate password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Check terms acceptance
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms and Conditions')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      const String apiUrl = 'http://10.10.10.15:8000/users';

      final Map<String, String> requestBody = {
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context);
      } else {
        final errorMessage = jsonDecode(response.body)['message'] ?? 'Registration failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                      const Text(
                        'Create Account',
                        style: AppTheme.headerStyle,
                      ),
                      const SizedBox(height: 30),
                      AppWidgets.inputField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        controller: _fullNameController,
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWidgets.inputField(
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            controller: _emailController,
                          ),
                          if (_emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Text(
                                _emailError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
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
                      const SizedBox(height: 16),
                      // Terms and Conditions Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptedTerms = value ?? false;
                              });
                            },
                            fillColor: MaterialStateProperty.resolveWith(
                                  (states) => states.contains(MaterialState.selected)
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'I accept the Terms and Conditions',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
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
                        text: 'Create Account',
                        onPressed: _createAccount,
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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
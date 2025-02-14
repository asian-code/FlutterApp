import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing
import '../../theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/* TO ACCESS THE SECURE TOKENS
String? jwtToken = await storage.read(key: 'jwt_token');
String? refreshToken = await storage.read(key: 'refresh_token');
 */

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
  bool _isLoading = false; // To show loading indicator during API call

  Widget _buildPasswordField() {
    return AppWidgets.inputField(
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
    );
  }
  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
      print('DEBUG: Loading indicator activated.');
    });

    try {
      const String apiUrl = 'http://10.10.10.15:8000/login';
      print('DEBUG: API URL set to $apiUrl.');

      // Prepare the request body
      final Map<String, String> requestBody = {
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      };
      print('DEBUG: Request body prepared: $requestBody.');

      // Make the POST request
      print('DEBUG: Sending POST request to $apiUrl...');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      print('DEBUG: POST request completed. Response status code: ${response.statusCode}.');

      // Parse the response
      if (response.statusCode != 500) {
        print('DEBUG: Successful response received. Parsing response data...');
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('DEBUG: Response data parsed: $responseData.');

        // Extract tokens from the response
        final String? jwtToken = responseData['access_token'];
        final String? refreshToken = responseData['refresh_token'];
        print('DEBUG: JWT Token: $jwtToken, Refresh Token: $refreshToken.');

        if (jwtToken != null && refreshToken != null) {
          print('DEBUG: Tokens found. Storing tokens securely...');
          const storage = FlutterSecureStorage();
          await storage.write(key: 'jwt_token', value: jwtToken);
          await storage.write(key: 'refresh_token', value: refreshToken);
          print('DEBUG: Tokens stored successfully.');

          // Navigate to the home screen after successful login
          print('DEBUG: Navigating to the home screen...');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          print('DEBUG: Tokens not found in the response.');
          throw Exception('Tokens not found in the response');
        }
      } else {
        print('DEBUG: Error response received. Status code: ${response.statusCode}.');
        // Handle API errors
        final errorMessage = jsonDecode(response.body)['message'] ?? 'An error occurred';
        print('DEBUG: Error message from server: $errorMessage.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      print('DEBUG: Exception caught: $error.');
      // Handle exceptions (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
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

                        hint: 'Email',
                        icon: Icons.person_outline,
                        controller: _usernameController,
                      ),
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
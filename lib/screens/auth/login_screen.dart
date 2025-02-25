import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../router.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/link_button.dart';
import '../../widgets/inputs/styled_text_field.dart';

class LoginScreen extends StatefulWidget {
  final bool isEmployee;

  const LoginScreen({
    Key? key,
    required this.isEmployee,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form state
  bool _isFormValid = false;
  String? _emailError;
  String? _passwordError;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  // Focus nodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);

    // Initialize the auth service to check for existing tokens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.initialize().then((_) {
        if (authService.isAuthenticated) {
          AppRouter.navigateToHome(context);
        }
      });
    });

    // Configure focus listeners
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() {
          _emailTouched = true;
          _validateForm();
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        setState(() {
          _passwordTouched = true;
          _validateForm();
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Only show errors if the fields have been touched
      _emailError = _emailTouched ? Validators.email(_emailController.text.trim()) : null;
      _passwordError = _passwordTouched ? Validators.password(_passwordController.text.trim()) : null;

      _isFormValid = _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _emailError == null &&
          _passwordError == null;
    });
  }

  Future<void> _login() async {
    // Force validation
    setState(() {
      _emailTouched = true;
      _passwordTouched = true;
    });
    _validateForm();

    if (!_isFormValid) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      AppRouter.navigateToHome(context);
    } else if (mounted && authService.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authService.error!),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: authService.isLoading && !_emailTouched && !_passwordTouched
            ? const Center(child: CircularProgressIndicator())
            : Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Image.asset(
                    AssetPaths.logo,
                    width: AppTheme.logoWidth,
                    fit: BoxFit.contain,
                  ),
                ),

                // Login form container
                Container(
                  width: AppTheme.containerWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(AppTheme.containerPadding),
                  decoration: AppTheme.containerDecoration,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.isEmployee ? 'Employee Login' : 'Sign In',
                        style: AppTheme.headingStyle,
                      ),
                      const SizedBox(height: 30),

                      // Email field
                      StyledTextField(
                        hint: 'Email',
                        icon: Icons.person_outline,
                        controller: _emailController,
                        errorText: _emailTouched ? _emailError : null,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      PasswordTextField(
                        controller: _passwordController,
                        errorText: _passwordTouched ? _passwordError : null,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _login(),
                      ),

                      // Forgot password link
                      LinkButton(
                        text: 'Forgot Password?',
                        onPressed: () {},
                        alignment: Alignment.centerRight,
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      GradientButton(
                        text: widget.isEmployee ? 'Employee Sign In' : 'Sign In',
                        onPressed: _login,
                        isLoading: authService.isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Create account link (only for regular users)
                      if (!widget.isEmployee)
                        Center(
                          child: LinkButton(
                            text: 'Not a member? Create account',
                            onPressed: () => AppRouter.navigateToCreateAccount(context),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Toggle between employee and customer login
                LinkButton(
                  text: widget.isEmployee
                      ? 'Return to Customer Login'
                      : 'Looking for Employee Portal? Click here',
                  onPressed: () => AppRouter.toggleEmployeeMode(context, widget.isEmployee),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
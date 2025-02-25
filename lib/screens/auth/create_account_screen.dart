import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/buttons/link_button.dart';
import '../../widgets/inputs/styled_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Form state
  bool _acceptedTerms = false;
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Focus nodes
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Set up focus listeners
    _fullNameFocusNode.addListener(() {
      if (!_fullNameFocusNode.hasFocus) {
        setState(() {
          _fullNameError = Validators.name(_fullNameController.text.trim());
        });
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        setState(() {
          _emailError = Validators.email(_emailController.text.trim());
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        setState(() {
          _passwordError = Validators.strongPassword(_passwordController.text);
        });
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _confirmPasswordError = Validators.passwordsMatch(
            _passwordController.text,
            _confirmPasswordController.text,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _fullNameError = Validators.name(_fullNameController.text.trim());
      _emailError = Validators.email(_emailController.text.trim());
      _passwordError = Validators.strongPassword(_passwordController.text);
      _confirmPasswordError = Validators.passwordsMatch(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });

    return _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _acceptedTerms;
  }

  Future<void> _createAccount() async {
    // Validate form
    if (!_validateForm()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept the Terms and Conditions')),
        );
      }
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.createAccount(
      _fullNameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pop(context);
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
        body: Center(
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

                // Create account form container
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
                      const Text(
                        'Create Account',
                        style: AppTheme.headingStyle,
                      ),
                      const SizedBox(height: 30),

                      // Full name field
                      StyledTextField(
                        hint: 'Full Name',
                        icon: Icons.person_outline,
                        controller: _fullNameController,
                        errorText: _fullNameError,
                        focusNode: _fullNameFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      StyledTextField(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        controller: _emailController,
                        errorText: _emailError,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      PasswordTextField(
                        hint: 'Password',
                        controller: _passwordController,
                        errorText: _passwordError,
                        focusNode: _passwordFocusNode,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Confirm password field
                      PasswordTextField(
                        hint: 'Confirm Password',
                        controller: _confirmPasswordController,
                        errorText: _confirmPasswordError,
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _createAccount(),
                      ),
                      const SizedBox(height: 16),

                      // Terms and conditions checkbox
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

                      // Create account button
                      GradientButton(
                        text: 'Create Account',
                        onPressed: _createAccount,
                        isLoading: authService.isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Sign in link
                      Center(
                        child: LinkButton(
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
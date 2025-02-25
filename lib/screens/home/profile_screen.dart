import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../router.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons/gradient_button.dart';
import '../../widgets/dialogs/warning_dialog.dart';
import '../../widgets/inputs/styled_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load user data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.userData != null) {
        _fullNameController.text = authService.userData!['full_name'] ?? '';
        _emailController.text = authService.userData!['email'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Update profile information
  void _updateProfile() {
    // TODO: Implement profile update logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  // Show delete account warning
  void _showDeleteWarning() {
    DialogHelper.showWarningDialog(
      context: context,
      title: 'Delete Account',
      message: 'Are you sure you want to delete your account? This is not reversible.',
      confirmText: 'DELETE',
      onConfirm: _deleteAccount,
      isDestructive: true,
    );
  }

  // Delete account
  Future<void> _deleteAccount() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.deleteAccount();

    if (success && mounted) {
      AppRouter.navigateToLogin(context);
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

  // Sign out
  Future<void> _signOut() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.signOut();

    if (mounted) {
      AppRouter.navigateToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Profile', style: AppTheme.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            border: Border.all(
                              color: AppTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.primaryColor,
                            size: 50,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.secondaryColor,
                              border: Border.all(
                                color: AppTheme.backgroundColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Form
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StyledTextField(
                    hint: 'Full Name',
                    icon: Icons.person,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 16),
                  StyledTextField(
                    hint: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: 'Update Profile',
                    onPressed: _updateProfile,
                    isLoading: authService.isLoading,
                  ),

                  // Security Section
                  const SizedBox(height: 32),
                  const Text(
                    'Security',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityOption(
                    'Change Password',
                    Icons.lock,
                        () {
                      // TODO: Implement change password flow
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildSecurityOption(
                    'Two-Factor Authentication',
                    Icons.security,
                        () {
                      // TODO: Implement 2FA flow
                    },
                  ),

                  // Danger Zone
                  const SizedBox(height: 32),
                  const Text(
                    'Danger Zone',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: AppTheme.buttonHeight,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      border: Border.all(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                    child: TextButton(
                      onPressed: authService.isLoading ? null : _showDeleteWarning,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                        ),
                      ),
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          color: authService.isLoading ? Colors.red.withOpacity(0.5) : Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Bottom spacing
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (authService.isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  /// Build a security option item
  Widget _buildSecurityOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          border: Border.all(
            color: AppTheme.textSecondaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.textSecondaryColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
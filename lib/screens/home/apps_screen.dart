import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons/gradient_button.dart';

class AppsScreen extends StatelessWidget {
  const AppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Apps', style: AppTheme.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Installed Apps section
              const Text(
                'Installed Apps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildAppsGrid(),
              const SizedBox(height: 32),

              // Available Services section
              const Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildServiceCard(
                'Premium Service',
                'Unlock advanced features',
                '9.99',
              ),
              const SizedBox(height: 16),
              _buildServiceCard(
                'Enterprise Plan',
                'Collaboration tools',
                '49.99',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a grid of app tiles
  Widget _buildAppsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 120).floor();
        crossAxisCount = crossAxisCount > 4 ? 4 : crossAxisCount;
        crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              constraints: const BoxConstraints(
                maxWidth: 120,
                maxHeight: 120,
              ),
              decoration: AppTheme.containerDecoration,
              child: Center(
                child: Text(
                  'App ${index + 1}',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Build a service card with title, description, and price
  Widget _buildServiceCard(String title, String description, String price) {
    return Container(
      decoration: AppTheme.containerDecoration,
      padding: const EdgeInsets.all(AppTheme.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTheme.buttonTextStyle),
              Text(
                '\$$price/mo',  // Fixed string interpolation
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: AppTheme.textSecondaryColor),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Get Started',
            onPressed: () {
              // Implement enrollment logic
            },
          ),
        ],
      ),
    );
  }}
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons/gradient_button.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('App Store', style: AppTheme.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured section
            const Text(
              'Featured Apps',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeaturedApp(
              'Premium Productivity Suite',
              'Boost your productivity with our all-in-one solution',
              '12.99',
            ),
            const SizedBox(height: 32),

            // Categories section
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildCategoriesGrid(),
            const SizedBox(height: 32),

            // New Releases section
            const Text(
              'New Releases',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildAppsList(),
          ],
        ),
      ),
    );
  }

  /// Build a featured app card
  Widget _buildFeaturedApp(String title, String description, String price) {
    return Container(
      width: double.infinity,
      decoration: AppTheme.containerDecoration,
      padding: const EdgeInsets.all(AppTheme.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.workspaces_rounded,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$$price/mo',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 120,
                child: GradientButton(
                  text: 'Install',
                  onPressed: () {
                    // Installation logic here
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build categories grid
  Widget _buildCategoriesGrid() {
    final categories = [
      {'icon': Icons.work, 'name': 'Productivity'},
      {'icon': Icons.videogame_asset, 'name': 'Games'},
      {'icon': Icons.photo_camera, 'name': 'Photo & Video'},
      {'icon': Icons.music_note, 'name': 'Music'},
      {'icon': Icons.fitness_center, 'name': 'Health & Fitness'},
      {'icon': Icons.book, 'name': 'Education'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: AppTheme.containerDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categories[index]['icon'] as IconData,
                color: AppTheme.primaryColor,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                categories[index]['name'] as String,
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build app list
  Widget _buildAppsList() {
    final apps = [
      {'name': 'Task Manager Pro', 'developer': 'Productivity Inc.', 'price': 'Free'},
      {'name': 'Photo Editor Plus', 'developer': 'Creative Tools Ltd.', 'price': '4.99'},
      {'name': 'Workout Tracker', 'developer': 'Health & Fitness Co.', 'price': 'Free'},
      {'name': 'Language Tutor', 'developer': 'Language Learning LLC', 'price': '9.99'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Container(
          decoration: AppTheme.containerDecoration,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.apps,
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apps[index]['name'] as String,
                      style: const TextStyle(
                        color: AppTheme.textPrimaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      apps[index]['developer'] as String,
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                    ),
                  ),
                  child: Text(
                    apps[index]['price'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
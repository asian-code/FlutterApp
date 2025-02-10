import 'package:flutter/material.dart';
import 'app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _getSelectedScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.cardColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Shop',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondaryColor,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeTab();
      case 1:
        return const ProfileTab();
      case 2:
        return const ShopTab();
      default:
        return const HomeTab();
    }
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> apps = [
      {'name': 'Calendar', 'icon': Icons.calendar_today},
      {'name': 'Messages', 'icon': Icons.message},
      {'name': 'Files', 'icon': Icons.folder},
      {'name': 'Notes', 'icon': Icons.note},
      {'name': 'Settings', 'icon': Icons.settings},
      {'name': 'Analytics', 'icon': Icons.analytics},
      {'name': 'Tasks', 'icon': Icons.task},
      {'name': 'Cloud', 'icon': Icons.cloud},
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Apps dashboard',
                  style: AppTheme.headingStyle,
                ),
                Container(
                  decoration: AppTheme.appCardDecoration,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20,
                        color: AppTheme.textPrimaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Add apps',
                        style: AppTheme.cardTitleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: AppTheme.appCardDecoration,
                    child: InkWell(
                      onTap: () {
                        // Handle app selection
                      },
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            apps[index]['icon'],
                            size: 32,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            apps[index]['name'],
                            style: AppTheme.cardTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: AppTheme.headingStyle,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: AppTheme.appCardDecoration,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'John Doe',
                    style: AppTheme.headingStyle,
                  ),
                  Text(
                    'john.doe@company.com',
                    style: AppTheme.cardTitleStyle.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: AppTheme.appCardDecoration,
              child: Column(
                children: [
                  _buildProfileTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    onTap: () {
                      // Handle edit profile
                    },
                  ),
                  _buildDivider(),
                  _buildProfileTile(
                    icon: Icons.security,
                    title: 'Security',
                    onTap: () {
                      // Handle security
                    },
                  ),
                  _buildDivider(),
                  _buildProfileTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Handle notifications
                    },
                  ),
                  _buildDivider(),
                  _buildProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {
                      // Handle settings
                    },
                  ),
                  _buildDivider(),
                  _buildProfileTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTheme.cardTitleStyle,
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}

class ShopTab extends StatelessWidget {
  const ShopTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> services = [
      {
        'name': 'Premium Subscription',
        'description': 'Access to all premium features',
        'price': '\$9.99/month',
        'icon': Icons.star,
      },
      {
        'name': 'Cloud Storage',
        'description': '100GB storage space',
        'price': '\$4.99/month',
        'icon': Icons.cloud,
      },
      {
        'name': 'Professional Support',
        'description': '24/7 priority support',
        'price': '\$19.99/month',
        'icon': Icons.support_agent,
      },
      {
        'name': 'Team Collaboration',
        'description': 'Up to 10 team members',
        'price': '\$29.99/month',
        'icon': Icons.group,
      },
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop',
              style: AppTheme.headingStyle,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: AppTheme.appCardDecoration,
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: AppTheme.getInputDecoration(
                  hint: 'Search services...',
                  icon: Icons.search,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: AppTheme.appCardDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              service['icon'],
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['name'],
                                  style: AppTheme.cardTitleStyle,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service['description'],
                                  style: AppTheme.cardTitleStyle.copyWith(
                                    color: AppTheme.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                service['price'],
                                style: AppTheme.cardTitleStyle.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AppWidgets.gradientButton(
                                text: 'Subscribe',
                                onPressed: () {
                                  // Handle purchase
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
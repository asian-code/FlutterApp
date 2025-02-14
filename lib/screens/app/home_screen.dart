import 'package:flutter/material.dart';
// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart'; // Import the package
import '../../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const MyAppsScreen(),
    const StoreScreen(),
    const ProfileScreen(),
  ];

  /// Controller for the PageView
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    // Dispose of the PageController to avoid memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: PageView(
          controller: _pageController, // Attach the PageController
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index; // Update the current index when the page changes
            });
          },
          children: _screens,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(16), // Add margin to create space around the bottom bar
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor, // Background color of the bottom bar
            borderRadius: BorderRadius.circular(30), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow for elevation effect
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30), // Clip the corners
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.backgroundColor, // Background color
              selectedItemColor: AppTheme.primaryColor, // Selected item color
              unselectedItemColor: AppTheme.textColorSecondary, // Unselected item color
              selectedFontSize: 10, // Font size for selected items
              unselectedFontSize: 10, // Font size for unselected items
              currentIndex: _currentIndex, // Current index
              onTap: (index) {
                setState(() {
                  _currentIndex = index; // Update the current index
                });
                _pageController.jumpToPage(index); // Navigate to the selected page
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.apps, size: 24),
                  label: 'My Apps',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.store, size: 24),
                  label: 'Store',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 24),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class MyAppsScreen extends StatelessWidget {
  const MyAppsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Apps', style: AppTheme.headerStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine number of columns based on screen width
          int crossAxisCount = (constraints.maxWidth / 120).floor();
          crossAxisCount = crossAxisCount > 4 ? 4 : crossAxisCount;
          crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;

          return GridView.builder(
            padding: const EdgeInsets.all(AppTheme.defaultPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1, // Ensures square cards
            ),
            itemCount: 8, // Replace with actual number of apps
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
                      color: AppTheme.textColorSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store', style: AppTheme.headerStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        children: [
          _buildServiceCard('Premium Service', 'Unlock advanced features'),
          const SizedBox(height: 16),
          _buildServiceCard('Enterprise Plan', 'Collaboration tools'),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String description) {
    return Container(
      decoration: AppTheme.containerDecoration,
      padding: const EdgeInsets.all(AppTheme.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.buttonTextStyle),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: AppTheme.textColorSecondary),
          ),
          const SizedBox(height: 16),
          AppWidgets.gradientButton(
            text: 'Enroll',
            onPressed: () {
              // Implement enrollment logic
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: AppTheme.headerStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            AppWidgets.inputField(
              hint: 'Full Name',
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            AppWidgets.inputField(
              hint: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            AppWidgets.gradientButton(
              text: 'Update Profile',
              onPressed: () {
                // Implement profile update logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
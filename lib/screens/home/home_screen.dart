import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/navigation/custom_bottom_navbar.dart';
import 'apps_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current page index
  int _currentIndex = 0;

  // Page controller
  final PageController _pageController = PageController(initialPage: 0);

  // List of navigation items
  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.apps_rounded, label: 'My Apps'),
    BottomNavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    BottomNavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  // List of screen pages
  final List<Widget> _pages = const [
    AppsScreen(),
    DashboardScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // Check authentication status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (!authService.isAuthenticated) {
        // If not authenticated, navigate back to login
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Handle page changes
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Handle bottom nav taps
  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
          items: _navItems,
        ),
      ),
    );
  }
}
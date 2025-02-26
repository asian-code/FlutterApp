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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // Current page index
  int _currentIndex = 0;

  // Page controller
  final PageController _pageController = PageController(initialPage: 0);

  // Animation controller
  late AnimationController _navBarAnimController;
  late Animation<Offset> _navBarOffsetAnimation;

  // Flag to track if navbar is fully visible
  bool _isNavBarFullyVisible = false;

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

    // Initialize animation controller
    _navBarAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _navBarOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.7), // Hide 70% of the navbar, leaving 30% peeking
    ).animate(CurvedAnimation(
      parent: _navBarAnimController,
      curve: Curves.easeInOut,
    ));

    // Start in peeking state
    _navBarAnimController.forward();

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
    _navBarAnimController.dispose();
    super.dispose();
  }

  // Show full navigation bar
  void _showFullNavBar() {
    if (!_isNavBarFullyVisible) {
      setState(() {
        _isNavBarFullyVisible = true;
      });
      _navBarAnimController.reverse();
    }
  }

  // Return to peeking state
  void _showPeekingNavBar() {
    if (_isNavBarFullyVisible) {
      setState(() {
        _isNavBarFullyVisible = false;
      });
      _navBarAnimController.forward();
    }
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
        body: GestureDetector(
          // Hide navbar when tapping away from it
          onTap: _showPeekingNavBar,
          behavior: HitTestBehavior.translucent,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
        ),
        bottomNavigationBar: GestureDetector(
          // Intercept taps on the navbar to prevent them from reaching the underlying GestureDetector
          onTap: () {
            _showFullNavBar();
            return;
          },
          child: SlideTransition(
            position: _navBarOffsetAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Peek indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.inputBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isNavBarFullyVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                    color: AppTheme.primaryColor,
                    size: 18,
                  ),
                ),
                // Actual navbar
                CustomBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: _onNavTap,
                  items: _navItems,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
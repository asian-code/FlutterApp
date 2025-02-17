import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart'; // Import the package
import '../../theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'custBottomNavbar.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller for PageView
  final _pageController = PageController(initialPage: 0);

  /// Controller for Notch Bottom Bar
  final _notchBottomBarController = NotchBottomBarController(index: 0);

  /// List of screens / pages
  final List<Widget> _pages = [
    const MyAppsScreen(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
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
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _notchBottomBarController,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          color: AppTheme.backgroundColor,
          showLabel: true,
          notchColor: AppTheme.primaryColor,
          bottomBarItems: [
            BottomBarItem(
              inActiveItem: Icon(
                Icons.apps_outlined,
                color: AppTheme.textColorSecondary,
              ),
              activeItem: Icon(
                Icons.apps,
                color: AppTheme.primaryColor,
              ),
              itemLabel: 'My Apps',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.dashboard_outlined,
                color: AppTheme.textColorSecondary,
              ),
              activeItem: Icon(
                Icons.dashboard,
                color: AppTheme.primaryColor,
              ),
              itemLabel: 'Dashboard',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.person_outline,
                color: AppTheme.textColorSecondary,
              ),
              activeItem: Icon(
                Icons.person,
                color: AppTheme.primaryColor,
              ),
              itemLabel: 'Profile',
            ),
          ],
          kIconSize: 24.0,
          kBottomRadius: 20.0,
          itemLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Installed Apps',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColorPrimary,
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
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
              const SizedBox(height: 32),
              const Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColorPrimary,
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
                '\$$price/mo',
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
            style: TextStyle(color: AppTheme.textColorSecondary),
          ),
          const SizedBox(height: 16),
          AppWidgets.gradientButton(
            text: 'Get Started',
            onPressed: () {
// Implement enrollment logic
            },
          ),
        ],
      ),
    );
  }
}
// #region Dashboard
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Dashboard', style: AppTheme.headerStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.containerDecoration,
              child: const UserActivityChart(),
            ),
            const SizedBox(height: 20),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.containerDecoration,
              child: const AppUsageChart(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserActivityChart extends StatelessWidget {
  const UserActivityChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Activity',
          style: TextStyle(
            color: AppTheme.textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 1,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppTheme.textColorSecondary.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: AppTheme.textColorSecondary.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const style = TextStyle(
                        color: AppTheme.textColorSecondary,
                        fontSize: 12,
                      );
                      Widget text;
                      switch (value.toInt()) {
                        case 0:
                          text = const Text('JAN', style: style);
                          break;
                        case 2:
                          text = const Text('MAR', style: style);
                          break;
                        case 4:
                          text = const Text('MAY', style: style);
                          break;
                        case 6:
                          text = const Text('JUL', style: style);
                          break;
                        default:
                          text = const Text('', style: style);
                          break;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: text,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${value.toInt()}k',
                          style: const TextStyle(
                            color: AppTheme.textColorSecondary,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 6,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(1, 2),
                    FlSpot(2, 4),
                    FlSpot(3, 3.5),
                    FlSpot(4, 4.5),
                    FlSpot(5, 3.8),
                    FlSpot(6, 5),
                  ],
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.secondaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.2),
                        AppTheme.secondaryColor.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppUsageChart extends StatefulWidget {
  const AppUsageChart({Key? key}) : super(key: key);

  @override
  State<AppUsageChart> createState() => _AppUsageChartState();
}

class _AppUsageChartState extends State<AppUsageChart> {
  int touchedIndex = -1;

  List<AppUsageData> appUsageData = [
    AppUsageData('Social Media', 35, AppTheme.primaryColor),
    AppUsageData('Productivity', 25, AppTheme.secondaryColor),
    AppUsageData('Entertainment', 20, Colors.orange),
    AppUsageData('Other', 20, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'App Usage Distribution',
          style: TextStyle(
            color: AppTheme.textColorPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: showingSections(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                appUsageData.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Indicator(
                    color: appUsageData[index].color,
                    text: appUsageData[index].name,
                    isSquare: true,
                    size: touchedIndex == index ? 18 : 16,
                    textColor: touchedIndex == index
                        ? AppTheme.textColorPrimary
                        : AppTheme.textColorSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      appUsageData.length,
          (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        final widgetSize = isTouched ? 55.0 : 40.0;

        return PieChartSectionData(
          color: appUsageData[i].color,
          value: appUsageData[i].percentage,
          title: '${appUsageData[i].percentage.toInt()}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColorPrimary,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          badgeWidget: isTouched
              ? Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: appUsageData[i].color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              appUsageData[i].name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : null,
          badgePositionPercentageOffset: 1.1,
        );
      },
    );
  }
}

// Custom Indicator Widget for the legend
class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = AppTheme.textColorPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
            borderRadius: isSquare ? BorderRadius.circular(4) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

// Data class for app usage
class AppUsageData {
  final String name;
  final double percentage;
  final Color color;

  AppUsageData(this.name, this.percentage, this.color);
}

// #endregion
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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  final _storage = const FlutterSecureStorage();

  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the JWT token from secure storage
      final token = await _storage.read(key: 'jwt_token');

      if (token == null) {
        throw Exception('Authentication required. Please login again.');
      }

      final response = await http.delete(
        Uri.parse('http://10.10.10.15:8000/delete/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        // Clear stored tokens
        await Future.wait([
          _storage.delete(key: 'jwt_token'),
          _storage.delete(key: 'refresh_token'),
        ]);

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      } else {
        // Handle different status codes
        String errorMessage = 'Failed to delete account. Please try again.';
        if (response.statusCode == 401) {
          errorMessage = 'Session expired. Please login again.';
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/');
          }
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => WarningDialog(
        title: 'Delete Account',
        message: 'Are you sure you want to delete your account? This is not reversible.',
        onConfirm: () {
          Navigator.of(context).pop(); // Close the dialog
          _deleteAccount(); // Call the delete account API
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: AppTheme.headerStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
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
                const SizedBox(height: 32),
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
                    onPressed: _isLoading ? null : () => _showDeleteWarning(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                      ),
                    ),
                    child: Text(
                      'Delete Account',
                      style: TextStyle(
                        color: _isLoading ? Colors.red.withOpacity(0.5) : Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
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
}

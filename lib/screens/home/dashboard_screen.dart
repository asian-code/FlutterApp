import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts/user_activity_chart.dart';
import '../../widgets/charts/app_usage_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Dashboard', style: AppTheme.headingStyle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.defaultPadding),
        child: Column(
          children: [
            // User Activity Chart
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.containerDecoration,
              child: const UserActivityChart(),
            ),
            const SizedBox(height: 20),

            // App Usage Chart
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.containerDecoration,
              child: const AppUsageChart(),
            ),

            // Additional Statistics
            const SizedBox(height: 20),
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  /// Build additional statistics section
  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.containerDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Daily Active Users', '5.2k', Icons.people)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Average Session', '12m 30s', Icons.timer)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard('Conversion Rate', '3.8%', Icons.sync_alt)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Revenue Growth', '+24%', Icons.trending_up)),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a statistics card with label, value, and icon
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            color: AppTheme.primaryColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

/// Chart displaying user activity
class UserActivityChart extends StatelessWidget {
  /// Optional activity data
  final List<FlSpot>? activityData;

  /// Optional title
  final String title;

  /// Optional minimum y-axis value
  final double minY;

  /// Optional maximum y-axis value
  final double maxY;

  /// Constructor
  const UserActivityChart({
    Key? key,
    this.activityData,
    this.title = 'User Activity',
    this.minY = 0,
    this.maxY = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = activityData ?? const [
      FlSpot(0, 3),
      FlSpot(1, 2),
      FlSpot(2, 4),
      FlSpot(3, 3.5),
      FlSpot(4, 4.5),
      FlSpot(5, 3.8),
      FlSpot(6, 5),
    ];

    return Column(
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
                    color: AppTheme.textSecondaryColor.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: AppTheme.textSecondaryColor.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: _bottomTitleWidgets,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: _leftTitleWidgets,
                    reservedSize: 42,
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: false,
              ),
              minX: 0,
              maxX: 6,
              minY: minY,
              maxY: maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: data,
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

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppTheme.textSecondaryColor,
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
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        '${value.toInt()}k',
        style: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
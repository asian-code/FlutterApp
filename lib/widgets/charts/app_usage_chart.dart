import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/app_usage_data.dart';

/// Chart for displaying app usage distribution
class AppUsageChart extends StatefulWidget {
  /// Data for the chart
  final List<AppUsageData>? appUsageData;

  /// Optional title
  final String title;

  /// Constructor
  const AppUsageChart({
    Key? key,
    this.appUsageData,
    this.title = 'App Usage Distribution',
  }) : super(key: key);

  @override
  State<AppUsageChart> createState() => _AppUsageChartState();
}

class _AppUsageChartState extends State<AppUsageChart> {
  int _touchedIndex = -1;
  late List<AppUsageData> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.appUsageData ?? AppUsageSampleData.getSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: AppTheme.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildSections(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  _data.length,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ChartIndicator(
                      color: _data[index].color,
                      text: _data[index].name,
                      isSquare: true,
                      size: _touchedIndex == index ? 18 : 16,
                      textColor: _touchedIndex == index
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(
      _data.length,
          (i) {
        final isTouched = i == _touchedIndex;
        final fontSize = isTouched ? 20.0 : 16.0;
        final radius = isTouched ? 110.0 : 100.0;
        final widgetSize = isTouched ? 55.0 : 40.0;

        return PieChartSectionData(
          color: _data[i].color,
          value: _data[i].percentage,
          title: '${_data[i].percentage.toInt()}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
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
              color: _data[i].color.withOpacity(0.9),
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
              _data[i].name,
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

/// Indicator widget for chart legends
class ChartIndicator extends StatelessWidget {
  /// Color of the indicator
  final Color color;

  /// Text label
  final String text;

  /// Whether to show as square or circle
  final bool isSquare;

  /// Size of the indicator
  final double size;

  /// Color of the text
  final Color? textColor;

  /// Constructor
  const ChartIndicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = AppTheme.textPrimaryColor,
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
  }}
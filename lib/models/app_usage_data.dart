import 'package:flutter/material.dart';

/// Data model for app usage information
class AppUsageData {
  final String name;
  final double percentage;
  final Color color;

  /// Constructor
  AppUsageData({
    required this.name,
    required this.percentage,
    required this.color,
  });

  /// Create from JSON
  factory AppUsageData.fromJson(Map<String, dynamic> json) {
    return AppUsageData(
      name: json['name'] as String,
      percentage: json['percentage'] as double,
      color: Color(json['color'] as int),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'percentage': percentage,
      'color': color.value,
    };
  }

  /// Create a copy with optional new values
  AppUsageData copyWith({
    String? name,
    double? percentage,
    Color? color,
  }) {
    return AppUsageData(
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
    );
  }
}

/// Sample data for testing and default values
class AppUsageSampleData {
  static List<AppUsageData> getSampleData() {
    return [
      AppUsageData(
        name: 'Social Media',
        percentage: 35,
        color: const Color(0xFF009688),
      ),
      AppUsageData(
        name: 'Productivity',
        percentage: 25,
        color: const Color(0xFF4FC3F7),
      ),
      AppUsageData(
        name: 'Entertainment',
        percentage: 20,
        color: Colors.orange,
      ),
      AppUsageData(
        name: 'Other',
        percentage: 20,
        color: Colors.purple,
      ),
    ];
  }
}
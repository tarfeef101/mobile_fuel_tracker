import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/trend_line_chart.dart';

/// Fullscreen view of a dashboard trend chart, rotatable to landscape for a
/// larger view of the data.
class ChartDetailScreen extends StatelessWidget {
  final String title;
  final List<FlSpot> points;
  final double? average;
  final String avgLabel;
  final String Function(double) yFormat;
  final String Function(double) tooltipFormat;

  const ChartDetailScreen({
    super.key,
    required this.title,
    required this.points,
    this.average,
    required this.avgLabel,
    required this.yFormat,
    required this.tooltipFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TrendLineChart(
          points: points,
          average: average,
          avgLabel: avgLabel,
          yFormat: yFormat,
          tooltipFormat: tooltipFormat,
        ),
      ),
    );
  }
}

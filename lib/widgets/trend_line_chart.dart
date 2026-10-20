import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Line chart with a real time x-axis, y-axis scale, and a dashed average
/// line. Pass [average] for a weighted value; the simple mean of [points]
/// is the fallback. Fills its parent unless [height] is given.
class TrendLineChart extends StatelessWidget {
  final List<FlSpot> points;
  final double? average;
  final String avgLabel;
  final String Function(double) yFormat;
  final String Function(double) tooltipFormat;
  final double? height;

  const TrendLineChart({
    super.key,
    required this.points,
    this.average,
    required this.avgLabel,
    required this.yFormat,
    required this.tooltipFormat,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = TextStyle(
      fontSize: 11,
      color: theme.colorScheme.onSurfaceVariant,
    );

    final average = this.average ??
        points.map((p) => p.y).reduce((a, b) => a + b) / points.length;
    // Include the average line so it can't draw outside the y range.
    final ys = [average, ...points.map((p) => p.y)];
    var minY = ys.reduce(min);
    var maxY = ys.reduce(max);
    final span = maxY - minY;
    final yPad = span > 0 ? span * 0.15 : (maxY.abs() > 0 ? maxY.abs() * 0.2 : 0.5);
    minY -= yPad;
    maxY += yPad;
    // Snap to tick boundaries; fl_chart would otherwise add extra labels at
    // the raw min/max on top of the interval labels.
    final yStep = _niceStep((maxY - minY) / 3);
    minY = (minY / yStep).floor() * yStep;
    maxY = (maxY / yStep).ceil() * yStep;

    var minX = points.map((p) => p.x).reduce(min);
    var maxX = points.map((p) => p.x).reduce(max);
    final xSpan = maxX - minX;
    if (xSpan == 0) {
      const day = 24 * 60 * 60 * 1000.0;
      minX -= day;
      maxX += day;
    } else {
      minX -= xSpan * 0.03;
      maxX += xSpan * 0.03;
    }

    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final chart = LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: points,
            barWidth: 2,
            color: theme.colorScheme.primary,
            dotData: const FlDotData(show: true),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            maxContentWidth: 160,
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      tooltipFormat(s.y),
                      TextStyle(
                        color: s.bar.color ?? theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ))
                .toList(),
          ),
        ),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: average,
              color: theme.colorScheme.onSurfaceVariant,
              strokeWidth: 1,
              dashArray: const [4, 4],
              label: HorizontalLineLabel(
                show: true,
                alignment: Alignment.topRight,
                style: labelStyle,
                labelResolver: (_) => avgLabel,
              ),
            ),
          ],
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yStep,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: yStep,
              reservedSize: 38,
              getTitlesWidget: (value, meta) => Text(yFormat(value), style: labelStyle),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxX - minX) / (landscape ? 5 : 3),
              reservedSize: 24,
              getTitlesWidget: (value, meta) => Text(
                DateFormat('MMM d').format(
                  DateTime.fromMillisecondsSinceEpoch(value.toInt()),
                ),
                style: labelStyle,
              ),
            ),
          ),
        ),
      ),
    );

    return height == null ? chart : SizedBox(height: height, child: chart);
  }

  /// Rounds a raw axis step to a 1/2/5 x 10^n value so labels stay tidy.
  static double _niceStep(double raw) {
    final magnitude = pow(10, (log(raw) / ln10).floor()).toDouble();
    for (final m in const [1.0, 2.0, 5.0, 10.0]) {
      if (raw <= m * magnitude) return m * magnitude;
    }
    return 10 * magnitude;
  }
}

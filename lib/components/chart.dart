import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ufc_delivery_app/extensions/app_colors.dart';

class BarChartScreen extends StatelessWidget {
  final bool embedded;
  final List<double> barData; // Add this parameter

  const BarChartScreen({
    this.embedded = false,
    required this.barData, // Ensure this is required
    super.key,
  });

  List<String> getLastSixMonths() {
    final List<String> monthLabels = [];
    final DateFormat dateFormat =
        DateFormat('MMM'); // This will format months as Jan, Feb, etc.

    // Get the current month
    DateTime currentMonth = DateTime.now();

    // Loop to get the last six months, including the current month
    for (int i = 0; i < 6; i++) {
      monthLabels.add(dateFormat.format(currentMonth));
      currentMonth = DateTime(currentMonth.year,
          currentMonth.month - 1); // Move to the previous month
    }

    return monthLabels.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final chart = Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(children: [
          AspectRatio(
            aspectRatio: 3,
            child: BarChart(
              BarChartData(
                maxY: 65,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 30,
                  drawVerticalLine: false,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    if (value == 30 || value == 60) {
                      return FlLine(
                        color: appColors.inactiveTabbarBtnTextColor,
                        strokeWidth: 1,
                      );
                    }
                    return FlLine(
                      color: Colors.transparent,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // final monthLabels = [
                        //   'Jan',
                        //   'Feb',
                        //   'Mar',
                        //   'Apr',
                        //   'May',
                        //   'Jun'
                        // ];
                        final List<String> monthLabels = getLastSixMonths();
                        if (value.toInt() >= 0 &&
                            value.toInt() < monthLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              monthLabels[value.toInt()],
                              style: const TextStyle(
                                color: inactiveTextColor2,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                        color: appColors.inactiveTabbarBtnTextColor, width: 1),
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide.none,
                  ),
                ),
                barGroups: _generateDummyBarGroups(barData),
              ),
            ),
          ),
        ]));

    return embedded
        ? chart
        : Scaffold(
            appBar: AppBar(
              title: const Text('Monthly Bar Chart'),
            ),
            body: Center(child: chart),
          );
  }

  List<BarChartGroupData> _generateDummyBarGroups(List<double> barData) {
    // final dummyData = [0.0, 35.0, 45.0, 45.0, 63.0, 33.0];
    return List.generate(
      barData.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: barData[index],
            color: index == 5 ? swipeBtnBgColor : inactiveBarColor,
            width: 8,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

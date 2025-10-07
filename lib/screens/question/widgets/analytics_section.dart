import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsSection extends StatelessWidget {
  final bool showAnalytics;
  const AnalyticsSection({super.key, required this.showAnalytics});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: ConstrainedBox(
          constraints: showAnalytics
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 0),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const Text(
                  "Question Analytics",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: 60,
                          title: "Correct 60%",
                          radius: 70,
                          titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.redAccent,
                          value: 30,
                          title: "Wrong 30%",
                          radius: 70,
                          titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.grey,
                          value: 10,
                          title: "Skipped 10%",
                          radius: 70,
                          titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

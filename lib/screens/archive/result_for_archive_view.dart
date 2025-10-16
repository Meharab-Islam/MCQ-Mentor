import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/archive/result_for_archive_controller.dart';
import 'package:pie_chart/pie_chart.dart';

class ResultForArchiveView extends StatelessWidget {
  final String examSectionId;
  final String examCategoryId;

  const ResultForArchiveView({
    super.key,
    required this.examSectionId,
    required this.examCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultForArchiveController(
      examSectionId: examSectionId,
      examCategoryId: examCategoryId,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("📄 Archive Exam Results"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.results.isEmpty) {
          return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.results.isEmpty) {
          return const Center(child: Text("No results found"));
        }

        // --- Calculate totals for chart & summary ---
        int totalCorrect = 0;
        int totalWrong = 0;
        int totalNotAnswered = 0;
        double totalMarks = 0;
        double totalObtained = 0;

        for (var result in controller.results) {
          totalCorrect += int.tryParse(result.correctAnswers) ?? 0;
          totalWrong += int.tryParse(result.wrongAnswers) ?? 0;
          totalNotAnswered += int.tryParse(result.notAnswered) ?? 0;
          totalMarks += double.tryParse(result.totalMarks) ?? 0.0;
          totalObtained += double.tryParse(result.obtainedMarks) ?? 0.0;
        }

        final averageMarks =
            controller.results.isNotEmpty ? totalObtained / controller.results.length : 0;

        final Map<String, double> chartData = {
          "Correct": totalCorrect.toDouble(),
          "Wrong": totalWrong.toDouble(),
          "Not Answered": totalNotAnswered.toDouble(),
        };

        final List<Color> chartColors = [
          Colors.greenAccent.shade400,
          Colors.redAccent,
          Colors.grey.shade400,
        ];

        return RefreshIndicator(
          onRefresh: () => controller.fetchResults(isRefresh: true),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== TOP: PIE CHART + SUMMARY =====
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      children: [
                        Text(
                          "Overall Result Summary",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(12.h),
                        PieChart(
                          dataMap: chartData,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: 120.r,
                          colorList: chartColors,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 24,
                          centerText: "Answers",
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.bottom,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValues: true,
                            showChartValuesOutside: false,
                            decimalPlaces: 0,
                          ),
                        ),
                        Gap(16.h),
                        Divider(),
                        // Total summary below chart
                        _buildRow("Total Exams", controller.results.length.toString()),
                        _buildRow("Total Marks", totalMarks.toStringAsFixed(2)),
                        _buildRow("Total Obtained", totalObtained.toStringAsFixed(2), isHighlighted: true),
                        _buildRow("Average Marks", averageMarks.toStringAsFixed(2)),
                        _buildRow("Total Correct", totalCorrect.toString()),
                        _buildRow("Total Wrong", totalWrong.toString()),
                        _buildRow("Total Not Answered", totalNotAnswered.toString()),
                      ],
                    ),
                  ),
                ),

                Gap(16.h),
          Text("Result List",style: TextStyle(fontSize: 25.sp,fontWeight: FontWeight.bold),),
                Gap(5.h),

                // ===== BOTTOM: INDIVIDUAL EXAM LIST =====
                ...controller.results.map((result) {
                  final obtained = double.tryParse(result.obtainedMarks) ?? 0.0;
                  final total = double.tryParse(result.totalMarks) ?? 0.0;
                  final percent =
                      total > 0 ? (obtained / total * 100).clamp(0, 100) : 0.0;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.examName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(6.h),
                          Text("Exam Date: ${result.examDate}"),
                          Text("Duration: ${result.duration} min"),
                          Gap(8.h),
                          const Divider(),
                          _row("Total Marks", result.totalMarks),
                          _row(
                            "Obtained Marks",
                            result.obtainedMarks,
                            isHighlighted: true,
                            isPass: obtained >= (total * 0.33),
                          ),
                          _row("Correct Answers", "${result.correctAnswers}"),
                          _row("Wrong Answers", "${result.wrongAnswers}"),
                          _row("Not Answered", "${result.notAnswered}"),
                          Gap(8.h),
                          LinearProgressIndicator(
                            value: percent / 100,
                            color: obtained >= (total * 0.33)
                                ? Colors.green
                                : Colors.red,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          Gap(6.h),
                          Text("Score: ${percent.toStringAsFixed(1)}%"),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    bool isHighlighted = false,
    bool isPass = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted
                  ? (isPass ? Colors.green : Colors.red)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  // --- Helper method to build a row ---


  Widget _row(
    String title,
    String value, {
    bool isHighlighted = false,
    bool isPass = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted
                  ? (isPass ? Colors.green : Colors.red)
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

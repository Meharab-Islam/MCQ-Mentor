import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/model/exam/exam_result_model.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:pie_chart/pie_chart.dart';

class ExamResultView extends StatelessWidget {
  final ExamResultData result;

  const ExamResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final AssessmentController controller = Get.put(AssessmentController());
    
    ScreenUtil.init(context, designSize: const Size(360, 690));

    final Map<String, double> chartData = {
      "Correct": result.correctAnswers.toDouble(),
      "Wrong": result.wrongAnswers.toDouble(),
      "Not Answered": result.notAnswered.toDouble(),
    };

    final List<Color> chartColors = [
      Colors.greenAccent.shade400,
      Colors.redAccent,
      Colors.grey.shade400,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppbar(title: 'Exam Analytics',),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ----------
            Center(
              child: Text(
                "Exam Performance Summary",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ---------- PIE CHART ----------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    PieChart(
                      dataMap: chartData,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 40,
                      chartRadius: 140.r,
                      colorList: chartColors,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 30,
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
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // ---------- STATISTICS ----------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Performance Breakdown",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    const Divider(),
                    _buildRow("Total Questions", result.totalQuestions.toString()),
                    _buildRow("Answered Questions", result.answeredQuestions.toString()),
                    _buildRow("Correct Answers", result.correctAnswers.toString()),
                    _buildRow("Wrong Answers", result.wrongAnswers.toString()),
                    _buildRow("Not Answered", result.notAnswered.toString()),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // ---------- MARKS SUMMARY ----------
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Marks Summary",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                    const Divider(),
                    _buildRow("Cut Mark per Wrong", result.cutMarkPerWrong.toStringAsFixed(2)),
                    _buildRow("Total Cut Marks", result.totalCutMarks.toStringAsFixed(2)),
                    _buildRow(
                      "Final Marks",
                      result.totalMarksAfterCut.toStringAsFixed(2),
                      isHighlighted: true,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // ---------- BUTTONS ----------
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.home),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
              ),
            ),
            Gap(10.h),
          ],
        ),
      ),
    );
    
  }

  Widget _buildRow(String title, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
              color: isHighlighted ? Get.theme.colorScheme.onPrimary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

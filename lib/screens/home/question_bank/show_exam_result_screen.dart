import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mcq_mentor/model/question_bank/question_bank_exam_result_model.dart';

class QuestionBankExamResultScreen extends StatelessWidget {
  final QuestionBankExamResultData result;

  const QuestionBankExamResultScreen({super.key, required this.result});

  Color getResultColor(String? resultStatus) {
    switch (resultStatus?.toLowerCase() ?? '') {
      case 'correct':
        return Colors.green;
      case 'wrong':
        return Colors.red;
      case 'not answered':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  IconData getResultIcon(String? resultStatus) {
    switch (resultStatus?.toLowerCase() ?? '') {
      case 'correct':
        return Icons.check_circle;
      case 'wrong':
        return Icons.cancel;
      case 'not answered':
        return Icons.remove_circle;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    // Ensure notAnswered is calculated even if null
    final notAnswered = result.notAnswered;

    final total = result.totalQuestions.toDouble();
    final correctPercent = total == 0 ? 0 : result.correctAnswers / total * 100;
    final wrongPercent = total == 0 ? 0 : result.wrongAnswers / total * 100;
    final notAnsweredPercent = total == 0 ? 0 : notAnswered / total * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Result"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Pie Chart
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    Text(
                      "Answer Distribution",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 200.h,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.green,
                              value: result.correctAnswers.toDouble(),
                              title: "${correctPercent.toStringAsFixed(1)}%",
                              radius: 50.r,
                              titleStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            PieChartSectionData(
                              color: Colors.red,
                              value: result.wrongAnswers.toDouble(),
                              title: "${wrongPercent.toStringAsFixed(1)}%",
                              radius: 50.r,
                              titleStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            PieChartSectionData(
                              color: Colors.grey,
                              value: notAnswered.toDouble(),
                              title: "${notAnsweredPercent.toStringAsFixed(1)}%",
                              radius: 50.r,
                              titleStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                          sectionsSpace: 2,
                          centerSpaceRadius: 30.r,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _legendCircle(Colors.green, "Correct"),
                        _legendCircle(Colors.red, "Wrong"),
                        _legendCircle(Colors.grey, "Not Answered"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Summary Cards with Icons
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryRow(Icons.help_outline, "Total Questions", result.totalQuestions),
                    _summaryRow(Icons.stacked_line_chart, "Total Marks", result.totalMarks),
                    _summaryRow(Icons.check_circle, "Correct Answers", result.correctAnswers),
                    _summaryRow(Icons.cancel, "Wrong Answers", result.wrongAnswers),
                    _summaryRow(Icons.remove_circle_outline, "Not Answered", notAnswered),
                    _summaryRow(Icons.star, "Obtained Marks", result.obtainedMarks),
                    _summaryRow(Icons.remove_circle, "Negative per Wrong", result.negativeMarkPerWrong),
                  ],
                ),
              ),
            ),

            /// 🔹 Detailed Questions
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: result.details.length,
              itemBuilder: (context, index) {
                final question = result.details[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: question.question ?? "",
                          style: {
                            "body": Style(
                                fontSize: FontSize(16.sp),
                                fontWeight: FontWeight.bold),
                          },
                        ),
                        SizedBox(height: 8.h),

                        /// Options
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: question.options.map((option) {
                            final isSelected = option == question.selectedAnswer;
                            final isCorrect = option == question.correctAnswer;

                            Color bgColor = Colors.white;
                            if (isCorrect) bgColor = Colors.green.withOpacity(0.3);
                            if (isSelected && !isCorrect) bgColor = Colors.red.withOpacity(0.3);

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4.h),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 12.w),
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.check_circle
                                        : isSelected
                                            ? Icons.cancel
                                            : Icons.circle_outlined,
                                    color: isCorrect
                                        ? Colors.green
                                        : isSelected
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Html(
                                      data: option,
                                      style: {
                                        "body": Style(
                                          fontSize: FontSize(14.sp),
                                        ),
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 6.h),

                        /// Result Indicator
                        Row(
                          children: [
                            Icon(
                              getResultIcon(question.result),
                              color: getResultColor(question.result),
                              size: 18,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              (question.result ?? "").toUpperCase(),
                              style: TextStyle(
                                color: getResultColor(question.result),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String title, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.blueAccent),
          SizedBox(width: 8.w),
          Text(
            "$title: $value",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _legendCircle(Color color, String text) {
    return Row(
      children: [
        Container(width: 12.w, height: 12.h, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 4.w),
        Text(text, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}

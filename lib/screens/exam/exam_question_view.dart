// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/exam/exam_question_controller.dart';
import 'package:mcq_mentor/controller/exam/exam_submit_controller.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/model/exam/exam_question_model.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class ExamQuestionView extends StatefulWidget {
  final int examId;
  final int duration; // Duration in minutes
  const ExamQuestionView({
    required this.examId,
    required this.duration,
    super.key,
  });

  @override
  State<ExamQuestionView> createState() => _ExamQuestionViewState();
}

class _ExamQuestionViewState extends State<ExamQuestionView> {
  late ExamQuestionController questionController;
  late ExamSubmitController submitController;
  final SubjectListController sectionController = Get.put(SubjectListController());

  @override
  void initState() {
    super.initState();
    questionController = Get.put(ExamQuestionController());
    submitController = Get.put(
      ExamSubmitController(
        examId: widget.examId,
        durationMinutes: widget.duration,
      ),
    );

    questionController.fetchExamQuestions(widget.examId);
    submitController.startExam();
  }

  @override
  void dispose() {
    Get.delete<ExamSubmitController>();
    Get.delete<ExamQuestionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const CustomAppbar(title: "Exam Questions"),
      body: Obx(() {
        if (questionController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary),
          );
        }

        final examData = questionController.examData.value;
        if (examData == null) {
          return const Center(child: Text("No data available"));
        }

        final questions = questionController.filteredQuestions;

        // ✅ Count answered questions
        final answeredCount = submitController.selectedAnswers.length;
        final totalQuestions = questions.length;
        final progress = totalQuestions == 0 ? 0.0 : answeredCount / totalQuestions;

        // Dynamic progress color
        Color progressColor;
        if (progress < 0.33) {
          progressColor = Colors.redAccent;
        } else if (progress < 0.66) {
          progressColor = Colors.orangeAccent;
        } else {
          progressColor = Colors.green;
        }

        return Column(
          children: [
            // 🔹 Dropdown + Timer
            Container(
              width: double.infinity,
              color: Get.theme.colorScheme.onPrimary.withAlpha(70),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 7.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() {
                      if (sectionController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                        );
                      }

                      final dropdownItems = <DropdownMenuItem<String>>[
                        const DropdownMenuItem(
                          value: '',
                          child: Text("All", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        ...sectionController.sections.map((section) {
                          return DropdownMenuItem<String>(
                            value: section.id.toString(),
                            child: Text(section.name),
                          );
                        }),
                      ];

                      String selectedValue = sectionController.selectedSectionId.value == 0
                          ? ''
                          : sectionController.selectedSectionId.value.toString();

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedValue,
                          isExpanded: true,
                          items: dropdownItems,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down_rounded, size: 26, color: Colors.grey),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.list_alt_rounded, color: Get.theme.colorScheme.onPrimary),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
                          onChanged: (value) {
                            if (value != null) {
                              int sectionId = value == '' ? 0 : int.parse(value);
                              questionController.filterQuestionsBySubject(sectionId);
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  Gap(10.w),
                  // Timer
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: submitController.remainingSeconds <= 60
                            ? Colors.redAccent
                            : Get.theme.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.white, size: 18),
                          SizedBox(width: 6.w),
                          Text(
                            submitController.formattedTime.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // 🔹 Progress section (Answered count + progress bar)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Answered: $answeredCount / $totalQuestions",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.onPrimary,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: progressColor,
                      minHeight: 8.h,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Question List
            Expanded(
              child: Obx(() {
                if (questions.isEmpty) {
                  return const Center(
                    child: Text("No questions available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...questions.map((question) => _questionCard(question)).toList(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              }),
            ),

            // 🔹 Submit Button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Obx(() {
                final isDisabled =
                    submitController.isLoading.value || submitController.isExamFinished.value;

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDisabled ? Colors.grey : Get.theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: isDisabled ? null : () => submitController.submitExam(),
                  icon: submitController.isLoading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Get.theme.colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    submitController.isLoading.value ? "Submitting..." : "Submit Exam",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _questionCard(Question question) {
    return Obx(() {
      final selected = question.selectedOption.value;
      final isExamFinished = submitController.isExamFinished.value;

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Question text (HTML or plain)
              Html(
                data: question.question ?? "No question text",
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(18.sp),
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white : Colors.black87,
                  ),
                },
              ),
              SizedBox(height: 8.h),

              // 🧩 Options
              ...question.options.asMap().entries.map((entry) {
                final optionIndex = entry.key;
                final option = entry.value;
                final isSelected = selected == option;

                // Label A/B/C/D or ক/খ/গ/ঘ
                final englishLabels = ['A', 'B', 'C', 'D', 'E', 'F'];
                final banglaLabels = ['ক', 'খ', 'গ', 'ঘ', 'ঙ', 'চ'];
                final optionLabel =
                    (question.template == 'bangla') ? banglaLabels[optionIndex] : englishLabels[optionIndex];

                return GestureDetector(
                  onTap: isExamFinished
                      ? null
                      : () {
                          question.selectedOption.value = option;
                          submitController.selectedAnswers[question.id] = option;
                        },
                  child: Opacity(
                    opacity: isExamFinished ? 0.6 : 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Get.theme.colorScheme.onPrimary.withAlpha(70)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Get.theme.colorScheme.onPrimary
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Get.theme.colorScheme.onPrimary
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Get.theme.colorScheme.onPrimary
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                optionLabel,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Html(
                              data: option,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  fontSize: FontSize(14.sp),
                                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

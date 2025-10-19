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
  final SubjectListController sectionController = Get.put(
    SubjectListController(),
  );

  @override
  void initState() {
    super.initState();

    // Controllers

    questionController = Get.put(ExamQuestionController());
    submitController = Get.put(
      ExamSubmitController(
        examId: widget.examId,
        durationMinutes: widget.duration,
      ),
    );

    // Fetch questions
    questionController.fetchExamQuestions(widget.examId);

    // Start exam timer
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
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary));
        }

        final examData = questionController.examData.value;
        if (examData == null) {
          return const Center(child: Text("No data available"));
        }

        return Column(
          children: [
            // 🔹 Timer section
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

                      // Dropdown items
                      final dropdownItems = <DropdownMenuItem<String>>[
                        const DropdownMenuItem(
                          value: '', // Show all subjects
                          child: Text(
                            "All",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        ...sectionController.sections.map((section) {
                          return DropdownMenuItem<String>(
                            value: section.id.toString(),
                            child: Text(section.name),
                          );
                        }),
                      ];

                      // Current selected value
                      String selectedValue =
                          sectionController.selectedSectionId.value == 0
                          ? ''
                          : sectionController.selectedSectionId.value
                                .toString();

                      return Container(
                        width: double.infinity, // Ensure it has a bounded width
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
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 26,
                            color: Colors.grey,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.list_alt_rounded,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (value) {
                            // Update selected section
                            if (value != null) {
                              int sectionId = value == ''
                                  ? 0
                                  : int.parse(value);
                              // sectionController.selectSection(sectionId);

                              // Filter questions in ExamQuestionController
                              questionController.filterQuestionsBySubject(
                                sectionId,
                              );
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  Gap(10.w),
                  // Timer widget remains unchanged
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: submitController.remainingSeconds <= 60
                            ? Colors.redAccent
                            : Get.theme.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 18,
                          ),
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

            // 🔹 Question List
            Expanded(
              child: Obx(() {
                final questions = questionController.filteredQuestions;

                if (questionController.isLoading.value) {
                  return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
                }

                if (questions.isEmpty) {
                  return const Center(
                    child: Text(
                      "No questions available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...questions
                          .map((question) => _questionCard(question))
                          .toList(),
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
                    submitController.isLoading.value ||
                    submitController.isExamFinished.value;

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDisabled
                        ? Colors.grey
                        : Get.theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 14.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: isDisabled
                      ? null
                      : () {
                          print(
                            "Selected Answers: ${submitController.selectedAnswers}",
                          );
                          submitController.submitExam();
                        },
                  icon: submitController.isLoading.value
                      ?  SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                           color: Get.theme.colorScheme.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    submitController.isLoading.value
                        ? "Submitting..."
                        : "Submit Exam",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: submitController.isLoading.value? Get.theme.colorScheme.onPrimary:Colors.white,
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
      final isExamFinished =
          submitController.isExamFinished.value; // ✅ check state

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Builder(
              builder: (_) {
                final text = question.question ?? "No question text";
                final bool isHtml = text.contains(
                  RegExp(r"<[^>]+>"),
                ); // detect HTML tags
      
                if (isHtml) {
                  // 🧩 Render HTML content
                  return Html(
                    data: text,
                    style: {
                      "html": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(20.sp),
                        color: Get.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      "div": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "span": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  );
                } else {
                  // 📝 Render plain text
                  return Text(
                    text,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              },
            ),
              SizedBox(height: 8.h),

              // ✅ Disable options if exam finished
              ...question.options.map((option) {
                final isSelected = selected == option;
                return GestureDetector(
                  onTap: isExamFinished
                      ? null // 🚫 disable tap
                      : () {
                          question.selectedOption.value = option;
                          submitController.selectedAnswers[question.id] =
                              option;
                          debugPrint("Selected: ${question.id} -> $option");
                        },
                  child: Opacity(
                    opacity: isExamFinished ? 0.6 : 1, // make look disabled
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 12.w,
                      ),
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
                        children: [
                          Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: isSelected
                                ? Get.theme.colorScheme.onPrimary
                                : Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Builder(
              builder: (_) {
                final text = option ?? "No question text";
                final bool isHtml = text.contains(
                  RegExp(r"<[^>]+>"),
                ); // detect HTML tags
      
                if (isHtml) {
                  // 🧩 Render HTML content
                  return Html(
                    data: text,
                    style: {
                      "html": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(14.sp),
                        color: Get.isDarkMode
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      "div": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                      "span": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  );
                } else {
                  // 📝 Render plain text
                  return Text(
                    text,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Get.isDarkMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              },
            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    });
  }
}

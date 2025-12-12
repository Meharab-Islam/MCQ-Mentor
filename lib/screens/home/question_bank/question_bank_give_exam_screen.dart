// question_bank_exam_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_give_exam_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_question_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_subcategory_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_category_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class QuestionBankGiveExamScreen extends StatefulWidget {
  final String categoryId;
  final int subCategoryId;

  const QuestionBankGiveExamScreen({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  State<QuestionBankGiveExamScreen> createState() =>
      _QuestionBankGiveExamScreenState();
}

class _QuestionBankGiveExamScreenState
    extends State<QuestionBankGiveExamScreen> {
  late final QuestionBankQuestionController questionController;
  late final QuestionBankGiveExamController examController;

  final QuestionBankCategoryController categoryController = Get.put(
    QuestionBankCategoryController(),
  );
  final QuestionBankSubCategoryController subCategoryController = Get.put(
    QuestionBankSubCategoryController(),
  );

  final Map<int, String> _selectedOptions = {}; // local selected options

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    questionController = Get.put(QuestionBankQuestionController());
    questionController.categoryId = widget.categoryId;
    questionController.subCategoryId = widget.subCategoryId;

    examController = Get.put(
      QuestionBankGiveExamController(
        examId: widget.subCategoryId,
        categoryId: widget.categoryId,
        subCategoryId: widget.subCategoryId,
      ),
    );

    // Load questions
    questionController.reloadForCategory(
      newCategoryId: widget.categoryId,
      newSubCategoryId: widget.subCategoryId,
    );

    // Observe when questions are loaded
    ever(questionController.questions, (_) {
      final questionCount = questionController.questions.length;
      if (questionCount > 0 && !examController.isExamStarted.value) {
        examController.initExam(controller: questionController);
      }
    });

    // Pagination listener
    questionController.scrollController.addListener(() {
      if (questionController.scrollController.position.pixels >=
              questionController.scrollController.position.maxScrollExtent -
                  200 &&
          !questionController.isLoading.value &&
          questionController.page.value < questionController.totalPages.value) {
        questionController.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    Get.delete<QuestionBankGiveExamController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const CustomAppbar(title: "Exam Questions"),
      body: Column(
        children: [
          /// 🔹 Timer + Negative Mark
          Container(
            width: double.infinity,
            color: Get.theme.colorScheme.onPrimary.withAlpha(70),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            child: Obx(() {
              // Default negative mark
              if (!examController.isExamStarted.value &&
                  examController.selectedNegativeMark.value == 0.0) {
                examController.selectedNegativeMark.value = 0.25;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Negative mark radio buttons
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.h,
                      horizontal: 7.w,
                    ),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Negative Mark: ",
                          style: TextStyle(
                            color: Get.theme.colorScheme.onPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [0.25, 0.5].map((value) {
                            return Row(
                              children: [
                                Obx(
                                  () => Radio<double>(
                                    value: value,
                                    groupValue: examController
                                        .selectedNegativeMark
                                        .value,
                                    activeColor:
                                        Get.theme.colorScheme.onPrimary,
                                    onChanged: (val) {
                                      if (val != null) {
                                        examController
                                                .selectedNegativeMark
                                                .value =
                                            val;
                                      }
                                    },
                                  ),
                                ),
                                Text(
                                  "$value",
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onPrimary,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  /// Timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: examController.remainingSeconds <= 60
                          ? Colors.redAccent
                          : Get.theme.colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer, color: Colors.white, size: 18),
                        SizedBox(width: 6.w),
                        Obx(
                          () => Text(
                            examController.formattedTime.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),

          /// 🔹 Answered Count + Progress Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Obx(() {
              final totalQuestions = questionController.questions.length;
              final answeredCount = examController.selectedAnswers.length;
              final progress = totalQuestions == 0
                  ? 0.0
                  : answeredCount / totalQuestions;

              Color progressColor;
              if (progress < 0.33) {
                progressColor = Colors.redAccent;
              } else if (progress < 0.66) {
                progressColor = Colors.orangeAccent;
              } else {
                progressColor = Colors.green;
              }

              return Column(
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
              );
            }),
          ),

          /// 🔹 Question List
          Expanded(
            child: Obx(() {
              if (questionController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                );
              }

              if (questionController.questions.isEmpty) {
                return const Center(child: Text("No questions found 😔"));
              }

              final questions = questionController.questions;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questions.map((question) {
                    final selected = _selectedOptions[question.id];
                    final isExamFinished = examController.isExamFinished.value;
                    final bool isQuestionLocked = _selectedOptions.containsKey(
                      question.id,
                    );

                    Color cardBackgroundColor;
                    if (isExamFinished) {
                      cardBackgroundColor = Colors.white;
                    } else if (isQuestionLocked) {
                      cardBackgroundColor = const Color.fromARGB(
                        255,
                        209,
                        214,
                        240,
                      );
                    } else {
                      cardBackgroundColor = Colors.white;
                    }

                    return Card(
                      elevation: 2,
                      color: cardBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(
                              data: question.question,
                              style: {
                                "body": Style(
                                  fontSize: FontSize(16.sp),
                                  fontWeight: FontWeight.bold,
                                  margin: Margins.all(0),
                                  padding: HtmlPaddings.all(0),
                                ),
                                "p": Style(
                                  fontSize: FontSize(16.sp),
                                  fontWeight: FontWeight.bold,
                                ),
                              },
                            ),
                            SizedBox(height: 8.h),
                            ...question.options.asMap().entries.map((entry) {
                              final int index = entry.key;
                              final String option = entry.value;
                              final isSelected = selected == option;

                              // Dynamic Label Logic
                              String optionLabel;
                              if (question.template.toLowerCase() ==
                                  "bangla") {
                                const bengaliLabels = [
                                  'ক',
                                  'খ',
                                  'গ',
                                  'ঘ',
                                  'ঙ',
                                  'চ',
                                ];
                                optionLabel = index < bengaliLabels.length
                                    ? bengaliLabels[index]
                                    : String.fromCharCode(
                                        0x0995 + index,
                                      ); // Fallback
                              } else {
                                const englishLabels = [
                                  'A',
                                  'B',
                                  'C',
                                  'D',
                                  'E',
                                  'F',
                                ];
                                optionLabel = index < englishLabels.length
                                    ? englishLabels[index]
                                    : String.fromCharCode(
                                        65 + index,
                                      ); // Fallback to A, B, C...
                              }

                              return GestureDetector(
                                onTap: isExamFinished || isQuestionLocked
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedOptions[question.id] =
                                              option;
                                          examController
                                                  .selectedAnswers[question
                                                  .id] =
                                              option;
                                        });
                                      },
                                child: Opacity(
                                  opacity: isExamFinished || isQuestionLocked
                                      ? 0.8
                                      : 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 12.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Get.theme.colorScheme.onPrimary
                                                .withAlpha(70)
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
                                        // Option Label (A/B/C/D or ক/খ/গ/ঘ)
                                        Container(
                                          width: 30.w,
                                          height: 30.w,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? Get
                                                      .theme
                                                      .colorScheme
                                                      .onPrimary
                                                : Colors.grey.shade200,
                                          ),
                                          child: Text(
                                            optionLabel,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Html(
                                            data: option,
                                            style: {
                                              "body": Style(
                                                fontSize: FontSize(15.sp),
                                                margin: Margins.all(0),
                                                padding: HtmlPaddings.all(0),
                                                color: Colors.black87,
                                              ),
                                            },
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color:
                                                Get.theme.colorScheme.onPrimary,
                                            size: 20.sp,
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
                  }).toList(),
                ),
              );
            }),
          ),

          /// 🔹 Submit Button
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Obx(() {
              final isDisabled =
                  examController.isLoading.value ||
                  examController.isExamFinished.value;

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
                    : () => examController.submitExam(),
                icon: examController.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle, color: Colors.white),
                label: Text(
                  examController.isLoading.value
                      ? "Submitting..."
                      : "Submit Exam",
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
      ),
    );
  }
}

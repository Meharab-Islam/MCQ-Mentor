import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/archive/archive_exam_submit_controller.dart';
import 'package:mcq_mentor/controller/archive/archive_question_controller.dart';
import 'package:mcq_mentor/controller/exam/exam_submit_controller.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class ArchiveGiveExamQuestionList extends StatefulWidget {
  final int archiveId;
  final int duration; // Duration in minutes
  const ArchiveGiveExamQuestionList({
    required this.archiveId,
    required this.duration,
    super.key,
  });

  @override
  State<ArchiveGiveExamQuestionList> createState() =>
      _ArchiveGiveExamQuestionListState();
}

class _ArchiveGiveExamQuestionListState
    extends State<ArchiveGiveExamQuestionList> {
  late ArchiveQuestionController questionController;
  late ArchiveExamSubmitController submitController;
  final SubjectListController sectionController =
      Get.put(SubjectListController());

  final Map<int, String> _selectedOptions = {}; // store selected answers locally

  @override
  void initState() {
    super.initState();

    questionController = Get.put(ArchiveQuestionController());
    submitController = Get.put(
      ArchiveExamSubmitController(
        examId: widget.archiveId,
        durationMinutes: widget.duration,
      ),
    );

    questionController.fetchQuestions(id: widget.archiveId);
    submitController.startExam(widget.archiveId);
  }

  @override
  void dispose() {
    Get.delete<ExamSubmitController>();
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
          // 🔹 Dropdown + Timer
          Container(
            width: double.infinity,
            color: Get.theme.colorScheme.onPrimary.withAlpha(70),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 7.w),
            child: Row(
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

                    String selectedValue =
                        sectionController.selectedSectionId.value == 0
                            ? ''
                            : sectionController.selectedSectionId.value
                                .toString();

                    return DropdownButtonFormField<String>(
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
                            horizontal: 14, vertical: 12),
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
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          int sectionId = value == '' ? 0 : int.parse(value);
                          questionController.filterQuestions(sectionId);
                        }
                      },
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

          // 🔹 Questions List
          Expanded(
            child: Obx(() {
              if (questionController.isLoading.value) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Get.theme.colorScheme.onPrimary,
                ));
              }

              final questions = questionController.questions;
              if (questions.isEmpty) {
                return const Center(
                  child: Text(
                    "No questions available 😔",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: questions.map((question) {
                    final selected = _selectedOptions[question.id];
                    final isExamFinished = submitController.isExamFinished.value;

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
                            Html(data: question.question),
                            SizedBox(height: 8.h),
                            ...question.options.map((option) {
                              final isSelected = selected == option;
                              return GestureDetector(
                                onTap: isExamFinished
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedOptions[question.id] = option;
                                          submitController.selectedAnswers[question.id] = option;
                                        });
                                      },
                                child: Opacity(
                                  opacity: isExamFinished ? 0.6 : 1,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 12.w),
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
                                          child: Text(option,
                                              style: TextStyle(fontSize: 14.sp)),
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
                  }).toList(),
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
                  backgroundColor: isDisabled ? Colors.grey : Get.theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                onPressed: isDisabled
                    ? null
                    : () {
                        submitController.submitExam(widget.archiveId);
                      },
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
      ),
    );
  }
}

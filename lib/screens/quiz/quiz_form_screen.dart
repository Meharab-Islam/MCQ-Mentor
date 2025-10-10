import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/quiz/quiz_form_controller.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/widget/textfield.dart';
import 'package:mcq_mentor/widget/under_maintance_screen.dart';

class QuizMasterScreen extends StatelessWidget {
  final QuizFormController formController = Get.put(QuizFormController());
  final SubjectListController subjectController = Get.put(SubjectListController());

  QuizMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology_outlined, size: 40.sp, color: Colors.grey[700]),
                Gap(10.w),
                Text(
                  'Quiz Master',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Gap(30.h),

            // Question Type Dropdown
            Text('Select Question Type', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            Gap(8.h),
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: formController.selectedQuestionType.value,
                      items: formController.questionTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          formController.selectedQuestionType.value = newValue;
                        }
                      },
                    ),
                  ),
                )),
            Gap(20.h),

            // Subject Dropdown
           // Subject Dropdown
Text('Select Subject', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
Gap(8.h),
Obx(() {
  if (subjectController.isLoading.value) {
    return Center(
      child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary),
    );
  } else {
    // Combine "সকল বিষয়" as default option + API-loaded subjects
    final allSubjects = [
      {'id': '0', 'name': 'সকল বিষয়'},
      ...subjectController.sections.map((section) => {'id': section.id.toString(), 'name': section.name})
    ];

    // Initialize selected subject if empty
    if (formController.selectedSubject.value.isEmpty) {
      formController.selectedSubject.value = '0'; // "সকল বিষয়" default
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: formController.selectedSubject.value,
          items: allSubjects.map((subject) {
            return DropdownMenuItem<String>(
              value: subject['id'],
              child: Text(subject['name']!),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              formController.selectedSubject.value = newValue;
            }
          },
        ),
      ),
    );
  }
}),

            Gap(20.h),

            // Number of Questions
            Text('Number of Questions', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            Gap(8.h),
            CustomTextField(
              hintText: "Number Of Questions",
              controller: formController.numberController,
              keyboardType: TextInputType.number,
            ),
            Gap(20.h),

            // Exam Time
            Text('Exam Time (minutes)', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
            Gap(8.h),
            CustomTextField(
              hintText: "Exam Time (minutes)",
              controller: formController.timeController,
              keyboardType: TextInputType.number,
            ),
            Gap(40.h),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(()=> UnderMaintanceScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: Text('Start Quiz', style: TextStyle(fontSize: 18.sp, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

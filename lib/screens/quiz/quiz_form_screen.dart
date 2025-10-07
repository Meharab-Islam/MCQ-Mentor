import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/quiz/quiz_form_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:mcq_mentor/widget/custom_drawer.dart';
import 'package:mcq_mentor/widget/textfield.dart';

class QuizMasterScreen extends StatelessWidget {
  final QuizFormController formController = Get.put(QuizFormController());

  QuizMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // appBar: const CustomAppbar(),
      // drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Master Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 40.sp,
                  color: Colors.grey[700],
                ),
                Gap(10.w),
                Text(
                  'Quiz Master',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Gap(30.h),

            // Select Question Type Dropdown
            Text(
              'Select Question Type',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Gap(8.h),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: formController.selectedQuestionType.value,
                    items: formController.questionTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        formController.selectedQuestionType.value = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
            Gap(20.h),

            // Select Subject Dropdown
            Text(
              'Select Subject',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Gap(8.h),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: formController.selectedSubject.value,
                    items: formController.subjects.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        formController.selectedSubject.value = newValue;
                      }
                    },
                  ),
                ),
              ),
            ),
            Gap(20.h),

            // Number of Questions TextField
            Text(
              'Number of Questions',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Gap(8.h),
            
            
            CustomTextField(hintText: "Number Of Questions", controller: formController.numberController, keyboardType: TextInputType.number,),
            Gap(20.h),

            // Exam Time TextField
            Text(
              'Exam Time (minutes)',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            Gap(8.h),
     
            CustomTextField(hintText: "Exam Time (minutes)", controller: formController.timeController, keyboardType: TextInputType.number,),
            Gap(40.h),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  formController.startQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      // The bottom navigation bar from the image
     
    );
  }
}
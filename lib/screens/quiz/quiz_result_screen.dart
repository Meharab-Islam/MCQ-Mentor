import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mcq_mentor/controller/quiz/quiz_controller.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizController quizController = Get.find();

  QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        automaticallyImplyLeading: false, // Prevents the back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInUp( // Animate the result text
              child: Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            Gap(20.h),
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Text(
                'Your Score:',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(10.h),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Obx(
                () => Text(
                  '${quizController.score.value} / ${quizController.totalQuestions}',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            Gap(40.h),
            FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: ElevatedButton(
                onPressed: () {
                  quizController.restartQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Go To Home',
                  style: TextStyle(fontSize: 18.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
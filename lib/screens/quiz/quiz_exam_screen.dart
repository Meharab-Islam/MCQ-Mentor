import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mcq_mentor/controller/quiz/quiz_controller.dart';

class QuizExamScreen extends StatelessWidget {
  final QuizController quizController = Get.put(QuizController());

  QuizExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${quizController.currentQuestionIndex.value + 1}/${quizController.totalQuestions}',
                style: TextStyle(fontSize: 18.sp),
              ),
              // Display the countdown timer
              _buildTimer(),
            ],
          ),
        ),
        centerTitle: false, // Adjusted to better fit the layout
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          final question = quizController.currentQuestion;
          final currentQuestionIndex = quizController.currentQuestionIndex.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  question.questionText,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(20.h),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final isSelected = quizController.userAnswers[currentQuestionIndex] == index;
                    final isCorrect = question.correctAnswerIndex == index;

                    // Determine border color based on selection and correctness
                    Color borderColor = Colors.grey.shade400;
                    if (quizController.userAnswers[currentQuestionIndex] != null) {
                      if (isSelected) {
                        borderColor = isCorrect ? Colors.green : Colors.red;
                      }
                    }

                    return FadeInRight(
                      delay: Duration(milliseconds: 200 * index),
                      child: GestureDetector(
                        onTap: () {
                          quizController.checkAnswer(index);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor, width: 2),
                            borderRadius: BorderRadius.circular(10.r),
                            color: isSelected ? borderColor.withOpacity(0.1) : null,
                          ),
                          child: Text(
                            question.options[index],
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Gap(20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Only allow moving to the next question if an answer is selected
                    if (quizController.userAnswers[currentQuestionIndex] != null) {
                      quizController.nextQuestion();
                    } else {
                      Get.snackbar(
                        'Warning',
                        'Please select an option before proceeding.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex < quizController.totalQuestions - 1 ? 'Next Question' : 'Finish Exam',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Helper method to build the timer widget
  Widget _buildTimer() {
    return Obx(() {
      final minutes = (quizController.timeRemaining.value ~/ 60).toString().padLeft(2, '0');
      final seconds = (quizController.timeRemaining.value % 60).toString().padLeft(2, '0');
      return Text(
        'Time: $minutes:$seconds',
        style: TextStyle(fontSize: 18.sp),
      );
    });
  }
}
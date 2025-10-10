import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mcq_mentor/screens/quiz/quiz_exam_screen.dart';

class QuizFormController extends GetxController {
  // Observables for form fields
  var selectedQuestionType = 'Random Quiz [Total Database]'.obs;
  var selectedSubject = ''.obs; // Will be set from SubjectListController
  final TextEditingController numberController = TextEditingController(text: '20');
  final TextEditingController timeController = TextEditingController(text: '5');

  // List for question type dropdown
  final List<String> questionTypes = [
    'Random Quiz [Total Database]',
    'Subject-wise Quiz',
    'Topic-wise Quiz',
  ];

  // Method to start the quiz
  void startQuiz() {
    final int numberOfQuestions = int.tryParse(numberController.text) ?? 0;
    final int examTime = int.tryParse(timeController.text) ?? 0;

    if (numberOfQuestions <= 0 || examTime <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Number of questions and exam time must be greater than zero.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(
      () => QuizExamScreen(),
      arguments: {
        'questionType': selectedQuestionType.value,
        'subject': selectedSubject.value,
        'numberOfQuestions': numberOfQuestions,
        'examTime': examTime,
      },
    );
  }

  @override
  void onClose() {
    numberController.dispose();
    timeController.dispose();
    super.onClose();
  }
}

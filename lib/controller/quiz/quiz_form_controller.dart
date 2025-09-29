import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mcq_mentor/screens/quiz/quiz_exam_screen.dart';

class QuizFormController extends GetxController {
  // Observables for form fields
  var selectedQuestionType = 'Random Quiz [Total Database]'.obs;
  var selectedSubject = 'সকল বিষয়'.obs;
  final TextEditingController numberController = TextEditingController(text: '20');
  final TextEditingController timeController = TextEditingController(text: '5');

  // Lists for dropdown menus
  final List<String> questionTypes = [
    'Random Quiz [Total Database]',
    'Subject-wise Quiz',
    'Topic-wise Quiz',
  ];

  final List<String> subjects = [
    'সকল বিষয়',
    'বাংলা',
    'English',
    'গণিত',
    'বিজ্ঞান',
    // Add more subjects here
  ];

  // A method to start the quiz
  void startQuiz() {
    // Get the values from the controllers
    final int numberOfQuestions = int.tryParse(numberController.text) ?? 0;
    final int examTime = int.tryParse(timeController.text) ?? 0;

    // You can perform validation here, e.g., if number of questions > 0
    if (numberOfQuestions <= 0 || examTime <= 0) {
      Get.snackbar(
        'Invalid Input',
        'Number of questions and exam time must be greater than zero.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Pass the form data to the next screen or a quiz-specific controller
    // For example, you can navigate to the quiz screen with arguments:
    Get.to(
      ()=> QuizExamScreen(),
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
import 'package:get/get.dart';
import 'package:mcq_mentor/model/quiz/quiz_model.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/screens/quiz/quiz_result_screen.dart';
import 'dart:async'; // Import the Timer class

class QuizController extends GetxController {
  // A list of quiz questions. This would likely come from an API in a real app.
  final List<QuizQuestion> _questions = [
    QuizQuestion(
      questionText: 'What is the capital of France?',
      options: ['Berlin', 'Paris', 'Madrid', 'Rome'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      questionText: 'Who painted the Mona Lisa?',
      options: ['Van Gogh', 'Picasso', 'Leonardo da Vinci', 'Monet'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      questionText: 'What is the largest planet in our solar system?',
      options: ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      correctAnswerIndex: 2,
    ),
    // Add more questions here
  ];

  // Observable variables to hold the state
  var currentQuestionIndex = 0.obs;
  var score = 0.obs;
  var userAnswers = <int?>[].obs;
  
  // New: Timer variables
  var timeRemaining = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Initialize userAnswers list with nulls for each question
    userAnswers.value = List.filled(_questions.length, null);

    // New: Get the exam time from the arguments and start the timer
    final args = Get.arguments;
    if (args != null && args['examTime'] != null) {
      timeRemaining.value = args['examTime'] * 60; // Convert minutes to seconds
      startTimer();
    }
  }

  // Getters for easy access in the UI
  List<QuizQuestion> get questions => _questions;
  QuizQuestion get currentQuestion => _questions[currentQuestionIndex.value];
  int get totalQuestions => _questions.length;

  // New: Method to start the countdown timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        // Time is up, finish the exam
        timer.cancel();
        finishExam();
      }
    });
  }

  // Method to handle a user's answer
  void checkAnswer(int selectedIndex) {
    if (userAnswers[currentQuestionIndex.value] == null) {
      userAnswers[currentQuestionIndex.value] = selectedIndex;
      if (selectedIndex == currentQuestion.correctAnswerIndex) {
        score.value++;
      }
    }
  }

  // Method to navigate to the next question
  void nextQuestion() {
    if (currentQuestionIndex.value < _questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      finishExam();
    }
  }

  // New: Method to finish the exam, called by both timer and button
  void finishExam() {
    _timer?.cancel(); // Cancel the timer
    Get.offAll(() => QuizResultScreen());
  }
  
  // Method to restart the quiz
  void restartQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    userAnswers.value = List.filled(_questions.length, null);
    Get.offAll(()=> CustomBottomNavBarScreen()); // Navigate back to the exam screen
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel the timer when the controller is disposed
    super.onClose();
  }
}
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_question_controller.dart';
import 'package:mcq_mentor/model/question_bank/question_bank_exam_result_model.dart';
import 'package:mcq_mentor/screens/home/question_bank/show_exam_result_screen.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class QuestionBankGiveExamController extends GetxController {
  final int examId;
  final String categoryId;
  final int subCategoryId;

  QuestionBankGiveExamController({
    required this.examId,
    required this.categoryId,
    required this.subCategoryId,
  });

  /// Timer state
  int remainingSeconds = 0;
  Timer? _timer;

  /// Reactive states
  var isExamStarted = false.obs;
  var isExamFinished = false.obs;
  var formattedTime = "00:00:00".obs;
  RxBool isLoading = false.obs;

  /// Negative mark selection
  RxDouble selectedNegativeMark = 0.25.obs;

  /// Selected answers
  var selectedAnswers = <int, String>{}.obs;

  /// Assessment Controller
  final AssessmentController aa = Get.put(AssessmentController());

  /// Question Controller reference (to access questions)
  late QuestionBankQuestionController questionController;

  /// Initialize exam duration and link controller
  void initExam({required QuestionBankQuestionController controller}) {
    questionController = controller;

    final int questionCount = questionController.questions.length;
    if (questionCount == 0) {
      remainingSeconds = 0;
      formattedTime.value = "00:00:00";
      return;
    }

    // Calculate total duration: 0.9 minutes per question
    final int calculatedDuration = (questionCount * 0.9).ceil();
    remainingSeconds = calculatedDuration * 60;
    formattedTime.value = _formatTime(remainingSeconds);

    // Start exam timer
    startExam();
  }

  /// Start the exam countdown
  void startExam() {
    if (isExamStarted.value || remainingSeconds <= 0) return;
    isExamStarted.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        formattedTime.value = _formatTime(remainingSeconds);
      } else {
        timer.cancel();
        submitExam();
      }
    });
  }

  /// Format seconds as hh:mm:ss
  String _formatTime(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  /// Submit exam answers
  Future<void> submitExam() async {
    if (isExamFinished.value) return;
    isExamFinished.value = true;
    _timer?.cancel();

    if (questionController.questions.isEmpty) {
      Get.snackbar(
        "⚠️ Submission Failed",
        "No questions available to submit.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Prepare answers in API format
      final List<Map<String, dynamic>> formattedAnswers = questionController.questions
          .map((q) => {
                "question_id": q.id.toString(),
                "selected_answer": selectedAnswers[q.id] ?? "",
              })
          .toList();

      final postData = {
        "question_bank_category_id": categoryId.toString(),
        "question_bank_sub_category_id": subCategoryId.toString(),
        "negativeMarkPerWrong": selectedNegativeMark.value.toString(),
        "answers": formattedAnswers,
      };

      debugPrint("📝 SUBMITTED EXAM DATA: $postData");

      final response = await ApiService().post(
        ApiEndpoint.submitQuestionBankExam,
        postData,
      );

      debugPrint("📘 API Response: ${response.data}");

      final resultModel = QuestionBankExamResultModel.fromJson(response.data);

      if (resultModel.success) {
        Get.snackbar(
          "✅ Exam Submitted",
          resultModel.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh exam sections
        aa.fetchExamSections();

        // Navigate to Question Bank Exam Result screen
        Get.off(() => QuestionBankExamResultScreen(result: resultModel.result));
      } else {
        Get.snackbar(
          "⚠️ Submission Failed",
          resultModel.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("❌ Error submitting exam: $e");
      Get.snackbar(
        "❌ Submission Failed",
        "Something went wrong while submitting your exam.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

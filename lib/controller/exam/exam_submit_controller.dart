import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/model/exam/exam_result_model.dart';
import 'package:mcq_mentor/screens/exam/exam_result_view.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ExamSubmitController extends GetxController {
  final int examId;
  final int durationMinutes;

  ExamSubmitController({required this.examId, required this.durationMinutes});

  /// Timer state
  late int remainingSeconds;
  Timer? _timer;

  /// Reactive states
  var isExamStarted = false.obs;
  var isExamFinished = false.obs;
  var formattedTime = "00:00:00".obs;
  RxBool isLoading = false.obs;

  var selectedAnswers = <int, String>{}.obs;
        AssessmentController aa = Get.put(AssessmentController());
  @override
  void onInit() {
    super.onInit();
    remainingSeconds = durationMinutes * 60;
    formattedTime.value = _formatTime(remainingSeconds);
  }

  /// Start the exam countdown
  void startExam() {
    if (isExamStarted.value) return;
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

  /// Format as hh:mm:ss
  String _formatTime(int seconds) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  /// Select an answer
  Future<void> submitExam() async {
    if (isExamFinished.value) return;
    isExamFinished.value = true;
    _timer?.cancel();

    // Show loading dialog
    isLoading.value = true;

    try {
      // Convert selectedAnswers keys to String
      final Map<String, String> formattedAnswers = selectedAnswers.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final postData = {
        "exam_id": examId.toString(),
        "answers": formattedAnswers, // {"17": "answer1", "18": "answer2"}
      };

      debugPrint("📝 SUBMITTED EXAM DATA: $postData");

      // Send POST request
      final response = await ApiService().post(
        ApiEndpoint.submitExam,
        postData,
      );
      debugPrint("📘 API Response: ${response.data}");

      // ✅ Parse response into model
      final resultModel = ExamResultModel.fromJson(response.data);

      if (resultModel.success) {
        isExamFinished.value = true;

        // ✅ Show success message
        Get.snackbar(
          "✅ Exam Submitted",
          resultModel.message, // safely access inner message
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Navigate to result analytics page

        aa.fetchExamSections();
        Get.off(() => ExamResultView(result: resultModel.data!));
      } else {
        // ❌ API returned failure
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

      // ❌ Show failure snackbar
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

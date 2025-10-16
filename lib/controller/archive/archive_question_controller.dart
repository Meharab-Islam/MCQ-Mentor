import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mcq_mentor/model/archive/archive_question_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class ArchiveQuestionController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// All questions fetched from API
  final List<ArchiveQuestionModel> allQuestions = [];

  /// Questions to display in UI (filtered)
  final RxList<ArchiveQuestionModel> questions = <ArchiveQuestionModel>[].obs;

  /// Fetch all questions for the archive (initial load)
  Future<void> fetchQuestions({required int id}) async {
    try {
      isLoading(true);

      final response = await _apiService.get(
        "${ApiEndpoint.archiveQuestions}/$id",
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'] as List;

        final List<ArchiveQuestionModel> fetchedQuestions = [];
        for (var item in data) {
          if (item['questions'] != null) {
            for (var q in item['questions']) {
              final question = ArchiveQuestionModel.fromJson(q);
              question.subjectId = item['subject_id'] ?? 0; // store subjectId
              fetchedQuestions.add(question);
            }
          }
        }

        allQuestions.clear();
        allQuestions.addAll(fetchedQuestions);

        // Initially filter by given subjectId
        filterQuestions(0);
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to fetch questions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Filter questions from allQuestions by subjectId
  void filterQuestions(int subjectId) {
    if (subjectId == 0) {
      // Show all
      questions.assignAll(allQuestions);
    } else {
      questions.assignAll(
        allQuestions.where((q) => q.subjectId == subjectId).toList(),
      );
    }
  }

  /// Called from UI when dropdown changes
  void reloadForSubject(int subjectId) {
    filterQuestions(subjectId);
  }
}

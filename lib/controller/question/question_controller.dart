import 'package:get/get.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/model/question/all_question_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class QuestionController extends GetxController {
  var questions = <Question>[].obs;
  var isLoading = false.obs;
  var page = 1.obs;
  var totalPages = 1.obs;

  final ApiService apiService = ApiService();
  final SubjectListController sectionController = Get.put(SubjectListController());

  @override
  void onInit() {
    super.onInit();
    fetchQuestions(pageNumber: 1);
  }

  /// Fetch questions with pagination and optional section filter
  Future<void> fetchQuestions({int pageNumber = 1}) async {
    if (isLoading.value) return;

    try {
      isLoading(true);

      // Determine subject filter: null if "All" is selected
      final subjectFilter = sectionController.selectedSectionId.value == 0
          ? null
          : sectionController.selectedSectionId.value;

      final queryParams = {
        'page': pageNumber.toString(),
        'per_page': 10,
        'subject_id': subjectFilter,
      }; // Remove null values

      final response = await apiService.get(
        ApiEndpoint.allQuestion,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<Question> fetchedQuestions =
            (response.data['data'] as List).map((q) => Question.fromJson(q)).toList();

        if (pageNumber == 1) {
          questions.assignAll(fetchedQuestions);
        } else {
          questions.addAll(fetchedQuestions);
        }

        totalPages.value = response.data['pagination']['total_page'] ?? 1;
        page.value = response.data['pagination']['current_page'] ?? 1;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch questions: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Load next page when scrolling
  Future<void> loadNextPage() async {
    if (page.value < totalPages.value) {
      await fetchQuestions(pageNumber: page.value + 1);
    }
  }

  /// Refresh questions (pull-to-refresh)
  Future<void> refreshQuestions() async {
    questions.clear();
    page.value = 1;
    await fetchQuestions(pageNumber: 1);
  }

  /// Reload questions when section changes
  void reloadForSection() {
    questions.clear();
    page.value = 1;
    fetchQuestions(pageNumber: 1);
  }
}

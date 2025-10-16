import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/live_exam_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class LiveExamController extends GetxController {
  /// Reactive variables
  final isLoading = false.obs;
  final liveExams = <LiveExamData>[].obs;
  final message = ''.obs;
  final date = ''.obs;

  final ApiService _apiService = ApiService();

  /// Fetch live exams filtered by query parameters
  Future<void> fetchLiveExams({
    required String examSectionId,
    String? examCategoryId,
  }) async {
    try {
      isLoading.value = true;
      message.value = '';
      liveExams.clear();

      // ✅ Prepare query parameters
      final queryParams = {
        'exam_section_id': examSectionId,
        if (examCategoryId != null) 'exam_category_id': examCategoryId,
      };

      // ✅ API Call
      final response = await _apiService.get(
        ApiEndpoint.liveExams,
        queryParameters: queryParams,
      );

      // ✅ Parse Response
      final data = LiveExamModel.fromJson(response.data);

      message.value = data.message;
      date.value = data.date;
      liveExams.assignAll(data.data);

      // ✅ Debug info
      print('✅ Live Exams fetched successfully: ${liveExams.length}');
    } catch (e, s) {
      // Log full error for debugging
      print('❌ Error fetching live exams: $e\n$s');
      message.value = "Failed to fetch live exams";
      liveExams.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

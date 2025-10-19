import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/live_exam_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class LiveExamController extends GetxController {
  /// Reactive variables
  final isLoading = false.obs;
  final liveExams = <LiveExamModel>{}.obs;
  final message = ''.obs;
  final date = ''.obs;
final exams = <LiveExamData>[].obs;     // ✅ individual exam items
final isSuccess = false.obs;           // ✅ success flag from API

  final ApiService _apiService = ApiService();

  /// Fetch live exams filtered by query parameters
  Future<void> fetchLiveExams({
  required String examSectionId,
  String? examCategoryId,
}) async {
  try {
    isLoading.value = true;
    exams.clear();
    message.value = '';
    date.value = '';
    isSuccess.value = false;

    final queryParams = {
      'exam_section_id': examSectionId,
      if (examCategoryId != null) 'exam_category_id': examCategoryId,
    };

    final response = await _apiService.get(
      ApiEndpoint.liveExams,
      queryParameters: queryParams,
    );

    final result = LiveExamModel.fromJson(response.data);

    // ✅ Assign parsed data
    isSuccess.value = result.success;
    message.value = result.message;
    date.value = result.date;
    exams.addAll(result.data);

    print('✅ Live Exams fetched: ${message.value}');
  } catch (e, s) {
    print('❌ Error fetching live exams: $e\n$s');
    isSuccess.value = false;
    message.value = "Failed to fetch live exams";
    exams.clear();
  } finally {
    isLoading.value = false;
  }
}


}

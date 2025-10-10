// live_exam_controller.dart
import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/live_exam_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class LiveExamController extends GetxController {
  var isLoading = false.obs;
  var liveExams = <LiveExamData>[].obs;
  var message = ''.obs;
  var date = ''.obs;


  /// Fetch live exams filtered by query parameters
  Future<void> fetchLiveExams({
    required String examSectionId,
    String? examCategoryId,
  }) async {
    try {
      isLoading.value = true;

      // Build query parameters
      final queryParams = {
        'exam_section_id': examSectionId,
        if (examCategoryId != null) 'exam_category_id': examCategoryId,
      };

      final response = await ApiService().get(
        ApiEndpoint.liveExams,
        queryParameters: queryParams,
      );

      final data = LiveExamModel.fromJson(response.data);

      message.value = data.message;
      date.value = data.date;
      liveExams.assignAll(data.data);
    } catch (e) {
      message.value = "Failed to fetch live exams: $e";
      liveExams.clear();
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/exam_details_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';


class ExamDetailsController extends GetxController {
  final int examId;
  ExamDetailsController(this.examId);

  var isLoading = true.obs;
  var examDetails = Rxn<ExamDetailsModel>();

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    fetchExamDetails();
    super.onInit();
  }

  Future<void> fetchExamDetails() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get("${ApiEndpoint.examDetails}$examId");

      if (response.statusCode == 200 && response.data['success'] == true) {
        examDetails.value =
            ExamDetailsModel.fromJson(response.data['data']);
      } else {
        debugPrint('Failed to load exam details');
      }
    } catch (e) {
      debugPrint('Error fetching exam details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mcq_mentor/model/exam/todays_activities_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class TodaysActivitiesController extends GetxController {
  final ApiService _apiService = ApiService();

  var todaysExams = <TodayExamData>[].obs;
  var totalExams = "0".obs;
  var submittedExams = "0".obs;
  var totalMarks = "0".obs;
  var totalDuration = "0".obs;
  var isLoading = false.obs;
  var remainingExams = "0".obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodaysActivities();
  }

  Future<void> fetchTodaysActivities() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiEndpoint.todaysActivities);

      if (response.statusCode == 200) {
        final model = TodaysActivitiesModel.fromJson(response.data);

        // ✅ Extract exams from nested data
        todaysExams.assignAll(model.data.exams);

        // ✅ Also store summary info
        totalExams.value = model.data.totalExams;
        submittedExams.value = model.data.submittedExams;
        totalMarks.value = model.data.totalMarks;
        totalDuration.value = model.data.totalDuration;
        remainingExams.value = model.data.remainingExams;
      } else {
        debugPrint('Failed to load activities: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Error fetching today\'s activities: ${e.response?.data ?? e.message}');
    } finally {
      isLoading.value = false;
    }
  }
}

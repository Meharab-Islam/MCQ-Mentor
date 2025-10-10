import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';
import 'package:mcq_mentor/model/exam_section/exam_section_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';


class AssessmentController extends GetxController {
  final ApiService _apiService = ApiService();

  var examSections = <ExamSectionData>[].obs;
  var isLoading = false.obs;
  var currentPage = 1;
  var perPage = 20;
  var hasNextPage = true.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    // Safe call after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchExamSections();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          hasNextPage.value) {
        fetchExamSections(page: currentPage + 1);
      }
    });
  }

  Future<void> fetchExamSections({int? page}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiEndpoint.examSection,
        queryParameters: {
          'page': page ?? currentPage,
          'per_page': perPage,
          'order': 'asc',
        },
      );

      if (response.statusCode == 200) {
        final model = ExamSectionsModel.fromJson(response.data);

        if (model.data != null && model.data!.isNotEmpty) {
          examSections.addAll(model.data!);
          currentPage = model.pagination?.currentPage ?? currentPage;
          hasNextPage.value =
              currentPage < (model.pagination?.totalPage ?? currentPage);
        } else {
          hasNextPage.value = false;
        }
      }
    } on DioException catch (e) {
      debugPrint('Error fetching Exam Sections: ${e.response?.data}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

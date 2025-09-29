import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import 'package:mcq_mentor/model/category_section/all_category_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class AllCategoryListController extends GetxController {
  final ApiService _apiService = ApiService();

  var examSectionId;

  AllCategoryListController({required this.examSectionId});

  /// Holds the actual category list
  var categoryList = <ExamCategory>[].obs;

  var isLoading = false.obs;
  var currentPage = 1;
  var perPage = 10;
  var hasNextPage = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchExamSections();

    // Infinite scroll listener
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
        ApiEndpoint.allCategoryList,
        queryParameters: {
          'page': page ?? currentPage,
          'per_page': perPage,
          'exam_section_id': examSectionId,
          'order': 'asc'
        },
      );

      if (response.statusCode == 200) {
        final model = ExamCategoriesResponse.fromJson(response.data);

        if (model.data.isNotEmpty) {
          categoryList.addAll(model.data);

          // Update pagination info
          currentPage = model.pagination.currentPage;
          hasNextPage.value = currentPage < model.pagination.totalPage;
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

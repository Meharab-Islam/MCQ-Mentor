import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mcq_mentor/model/exam_list_model.dart';

import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ExamItemListController extends GetxController {
  final ApiService _apiService = ApiService();

  var itemList = <ExamItem>[].obs;
  var isLoading = false.obs;

  var currentPage = 1;
  var perPage = 20;
  var hasNextPage = true.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchExamItems();

    // infinite scroll
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          hasNextPage.value) {
        fetchExamItems(page: currentPage + 1);
      }
    });
  }

  Future<void> fetchExamItems({int? page}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiEndpoint.examItemList,
        queryParameters: {
          'page': page ?? currentPage,
          'per_page': perPage,
          'order':'asc'
        },
      );

      if (response.statusCode == 200) {
        final model = ExamItemListResponse.fromJson(response.data);

        if (model.data.isNotEmpty) {
          itemList.addAll(model.data);

          currentPage = model.pagination.currentPage;
          hasNextPage.value = currentPage < model.pagination.totalPage;
        } else {
          hasNextPage.value = false;
        }
      }
    } on DioException catch (e) {
      debugPrint('Error fetching Exam Items: ${e.response?.data}');
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

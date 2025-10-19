import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/question_bank/question_bank_category_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class QuestionBankCategoryController extends GetxController {
  // Observables
  var categories = <QuestionBankCategory>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1.obs;
  var totalPage = 1.obs;

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();

    // Scroll listener for pagination
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 150 &&
        !isMoreLoading.value &&
        currentPage.value < totalPage.value) {
      fetchMoreCategories();
    }
  }

  /// Fetch first page or refresh
  Future<void> fetchCategories({int page = 1}) async {
    try {
      if (page == 1) isLoading.value = true;

      final response = await ApiService().get(
        ApiEndpoint.questionBankCategory,
        queryParameters: {"page": page.toString()},
      );

      final data = QuestionBankCategoryResponse.fromJson(response.data);

      if (page == 1) {
        categories.assignAll(data.data);
      } else {
        categories.addAll(data.data);
      }

      totalPage.value = data.pagination.totalPage;
      currentPage.value = data.pagination.currentPage;
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories: $e");
    } finally {
      if (page == 1) isLoading.value = false;
    }
  }

  /// Fetch next page for infinite scroll
  Future<void> fetchMoreCategories() async {
    if (currentPage.value >= totalPage.value) return;

    try {
      isMoreLoading.value = true;
      final nextPage = currentPage.value + 1;

      final response = await ApiService().get(
        ApiEndpoint.questionBankCategory,
        queryParameters: {"page": nextPage.toString()},
      );

      final data = QuestionBankCategoryResponse.fromJson(response.data);

      categories.addAll(data.data);
      currentPage.value = nextPage;
    } catch (e) {
      print('Error loading more categories: $e');
    } finally {
      isMoreLoading.value = false;
    }
  }

  /// Manually go to next page (optional)
  void nextPage() {
    if (currentPage.value < totalPage.value) {
      fetchMoreCategories();
    }
  }

  /// Manually go to previous page (optional)
  void previousPage() {
    if (currentPage.value > 1) {
      fetchCategories(page: currentPage.value - 1);
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
  }
}

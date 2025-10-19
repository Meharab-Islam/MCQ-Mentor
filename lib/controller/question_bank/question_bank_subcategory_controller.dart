import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/question_bank/question_bank_subcategory_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class QuestionBankSubCategoryController extends GetxController {
  /// Data and State
  var subCategories = <QuestionBankSubCategory>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1.obs;
  var totalPage = 1.obs;

  /// Scroll controller for pagination
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();

    /// Listen for scroll events
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isMoreLoading.value &&
          currentPage.value < totalPage.value) {
        /// Load next page when user nears bottom
        loadMore(currentCategoryId);
      }
    });
  }

  int currentCategoryId = 0; // store categoryId for reuse

  /// Initial fetch
  Future<void> fetchSubCategories(int categoryId, {int page = 1}) async {
    currentCategoryId = categoryId;
    if (page == 1) subCategories.clear(); // Reset list for first load

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final response = await ApiService().get(
        ApiEndpoint.questionBankSubCategorye,
        queryParameters: {
          'page': page,
          'categorySearch': categoryId,
        },
      );

      final data = QuestionBankSubCategoryResponse.fromJson(response.data);

      if (page == 1) {
        subCategories.assignAll(data.data);
      } else {
        subCategories.addAll(data.data);
      }

      totalPage.value = data.pagination.totalPage;
      currentPage.value = data.pagination.currentPage;
    } catch (e) {
      print('Error fetching subcategories: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Load next page
  Future<void> loadMore(int categoryId) async {
    if (currentPage.value < totalPage.value) {
      await fetchSubCategories(categoryId, page: currentPage.value + 1);
    }
  }
}

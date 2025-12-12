import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/question_bank/question_bank_question_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class QuestionBankQuestionController extends GetxController {
  var questions = <QuestionBankQuestion>[].obs;
  var isLoading = false.obs;
  var page = 1.obs;
  var totalPages = 1.obs;

  String categoryId = "0"; // Selected Category
  int subCategoryId = 0; // Selected SubCategory

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();

    scrollController.addListener(() {
      // Load next page when near bottom
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !isLoading.value &&
          page.value < totalPages.value) {
        loadNextPage();
      }
    });
  }

  Future<void> fetchQuestions({int pageNum = 1}) async {
    try {
      if (pageNum == 1) isLoading.value = true; // main loader for first page
      if (pageNum > 1)
        isLoading.value = true; // optional: show bottom loader for pagination

      final response = await ApiService().get(
        ApiEndpoint.questionBank,
        queryParameters: {
          "page": pageNum.toString(),
          "per_page": "5000",
          "question_bank_category_id": categoryId.toString(),
          "question_bank_sub_category_id": subCategoryId.toString(),
        },
      );

      final data = QuestionBankQuestionResponse.fromJson(response.data);

      // Update list first
      if (pageNum == 1) {
        questions.assignAll(data.data); // first page replaces old list
      } else {
        questions.addAll(data.data); // next pages append
      }

      // Update pagination info
      page.value = data.currentPage;
      totalPages.value = data.totalPages;
    } catch (e) {
      print('Error fetching question bank questions: $e');
    } finally {
      // Hide loader after data is fully assigned
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (page.value < totalPages.value && !isLoading.value) {
      isLoading.value = true; // show loader while fetching next page
      fetchQuestions(pageNum: page.value + 1);
    }
  }

  /// Reload questions for new category/subcategory
  void reloadForCategory({
    required String newCategoryId,
    int newSubCategoryId = 0,
  }) {
    isLoading.value = true; // ✅ Force loader immediately
    categoryId = newCategoryId;
    subCategoryId = newSubCategoryId;
    page.value = 1;
    fetchQuestions(pageNum: 1);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

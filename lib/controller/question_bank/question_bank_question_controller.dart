// question_bank_question_controller.dart
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

  String categoryId = "0";      // Selected Category
  int subCategoryId = 0;   // Selected SubCategory

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();

    scrollController.addListener(() {
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
      if (pageNum == 1) isLoading.value = true;

      final response = await ApiService().get(
        ApiEndpoint.questionBank,
        queryParameters: {
          "page": pageNum.toString(),
          if (categoryId != "0") "question_bank_category_id": categoryId.toString(),
          if (subCategoryId != 0) "question_bank_sub_category_id": subCategoryId.toString(),
        },
      );

      final data = QuestionBankQuestionResponse.fromJson(response.data);

      if (pageNum == 1) {
        questions.assignAll(data.data);
      } else {
        questions.addAll(data.data);
      }

      page.value = data.currentPage;
      totalPages.value = data.totalPages;
    } catch (e) {
      Get.snackbar("Error", "Failed to load questions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loadNextPage() {
    if (page.value < totalPages.value && !isLoading.value) {
      fetchQuestions(pageNum: page.value + 1);
    }
  }

  /// Reload questions for new category/subcategory
  void reloadForCategory({required String newCategoryId, int newSubCategoryId = 0}) {
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

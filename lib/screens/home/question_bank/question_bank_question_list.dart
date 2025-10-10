// question_bank_question_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_category_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_subcategory_controller.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_question_controller.dart';
import 'package:mcq_mentor/screens/question/widgets/question_card.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class QuestionBankQuestionList extends StatefulWidget {
  final String categoryId;
  final int subCategoryId;

  const QuestionBankQuestionList({
    super.key,
    required this.categoryId,
    required this.subCategoryId,
  });

  @override
  State<QuestionBankQuestionList> createState() =>
      _QuestionBankQuestionListState();
}

class _QuestionBankQuestionListState extends State<QuestionBankQuestionList> {
  late final QuestionBankQuestionController questionController;
  final QuestionBankCategoryController categoryController =
      Get.put(QuestionBankCategoryController());
  final QuestionBankSubCategoryController subCategoryController =
      Get.put(QuestionBankSubCategoryController());

  final Map<int, bool> _showCorrectMap = {};
  final Map<int, bool> _analyticsMap = {};
  final Map<int, bool> _favoriteMap = {};

  void toggleShowCorrect(int id) =>
      setState(() => _showCorrectMap[id] = !(_showCorrectMap[id] ?? false));
  void toggleAnalytics(int id) =>
      setState(() => _analyticsMap[id] = !(_analyticsMap[id] ?? false));
  void toggleFavorite(int id) =>
      setState(() => _favoriteMap[id] = !(_favoriteMap[id] ?? false));

  @override
  void initState() {
    super.initState();

    // Initialize controller with passed category and subcategory
    questionController = Get.put(QuestionBankQuestionController());
    questionController.categoryId = widget.categoryId;
    questionController.subCategoryId = widget.subCategoryId;
    questionController.reloadForCategory(
        newCategoryId: widget.categoryId, newSubCategoryId: widget.subCategoryId);
    // Scroll listener for pagination
    questionController.scrollController.addListener(() {
      if (questionController.scrollController.position.pixels >=
              questionController.scrollController.position.maxScrollExtent - 200 &&
          !questionController.isLoading.value &&
          questionController.page.value < questionController.totalPages.value) {
        questionController.loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Questions",
      ),
      body: Column(
        children: [
          // 🔹 Category Dropdown
         
          // 🔹 Question List
          Expanded(
            child: Obx(() {
              if (questionController.isLoading.value &&
                  questionController.questions.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                      color: Get.theme.colorScheme.onPrimary),
                );
              }

              if (questionController.questions.isEmpty) {
                return const Center(child: Text("No questions found 😔"));
              }

              return ListView.builder(
                controller: questionController.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: questionController.questions.length +
                    (questionController.page.value <
                            questionController.totalPages.value
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index == questionController.questions.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final question = questionController.questions[index];
                  final showCorrect = _showCorrectMap[question.id] ?? false;
                
                  final isFavorite = _favoriteMap[question.id] ?? false;

                  return QuestionCard(
                    question: question,
                    showCorrect: showCorrect,
                    showAnalytics: false,
                    isShowAnalytics: false,
                    isShowFavorite: false,
                    isFavorite: isFavorite,
                    onToggleCorrect: () => toggleShowCorrect(question.id),
                    onToggleAnalytics: () => toggleAnalytics(question.id),
                    onToggleFavorite: () => toggleFavorite(question.id),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

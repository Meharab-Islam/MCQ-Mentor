import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/archive/archive_question_controller.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/screens/question/widgets/question_card.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class ArchiveQuestionListView extends StatefulWidget {
  bool isShowAnalytics = true;
  String examSectionSd;
  String examSectionCategoryId;
  int archiveId;

  ArchiveQuestionListView({
    super.key,
    required this.isShowAnalytics,
    required this.examSectionSd,
    required this.examSectionCategoryId,
    required this.archiveId,
  });

  @override
  State<ArchiveQuestionListView> createState() =>
      _ArchiveQuestionListViewState();
}

class _ArchiveQuestionListViewState extends State<ArchiveQuestionListView> {
  final ArchiveQuestionController controller = Get.put(
    ArchiveQuestionController(),
  );
  final SubjectListController sectionController = Get.put(
    SubjectListController(),
  );
  final ScrollController _scrollController = ScrollController();

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
  Widget build(BuildContext context) {
    controller.fetchQuestions(id: widget.archiveId);
    return Scaffold(
      appBar: CustomAppbar(),
      body: Column(
        children: [
          // 🔹 Dropdown at top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() {
              if (sectionController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary),
                );
              }

              // Dropdown items
              final dropdownItems = <DropdownMenuItem<String>>[
                const DropdownMenuItem(
                  value: '', // default "All"
                  child: Text(
                    "All",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ...sectionController.sections.map((section) {
                  return DropdownMenuItem<String>(
                    value: section.id.toString(),
                    child: Text(section.name),
                  );
                }),
              ];

              // Default value
              String selectedValue =
                  sectionController.selectedSectionId.value == 0
                  ? ''
                  : sectionController.selectedSectionId.value.toString();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedValue,
                  isExpanded: true,
                  items: dropdownItems,
                  dropdownColor: Colors.white,
                  icon: const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 26,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.list_alt_rounded,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,

                    labelStyle: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      controller.reloadForSubject(
                        value == '' ? 0 : int.parse(value),
                      );
                    }
                  },
                ),
              );
            }),
          ),

          // 🔹 Question List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.questions.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                );
              }

              if (controller.questions.isEmpty) {
                return const Center(child: Text("No questions found 😔"));
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: controller.questions.length + 1,
                itemBuilder: (context, index) {
                  // 🔹 Check if index is last item
                  if (index == controller.questions.length) {
                    // You can return a loading indicator or empty space
                    return controller.isLoading.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final question = controller.questions[index];
                  final showCorrect = _showCorrectMap[question.id] ?? false;
                  final showAnalytics = _analyticsMap[question.id] ?? false;
                  final isFavorite = question.favorite;

                  return QuestionCard(
                    sectionId: int.parse(widget.examSectionSd),
                    categoryId: int.parse(widget.examSectionCategoryId),
                    archiveId: widget.archiveId,
                    question: question,
                    showCorrect: showCorrect,
                    showAnalytics: showAnalytics,
                    isShowAnalytics: widget.isShowAnalytics,
                    isFavorite: isFavorite,
                    onToggleCorrect: () => toggleShowCorrect(question.id),
                    onToggleAnalytics: () => toggleAnalytics(question.id),
                   
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question/question_controller.dart';
import 'package:mcq_mentor/controller/subject/subject_list_controller.dart';
import 'package:mcq_mentor/screens/question/widgets/question_card.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class QuestionListPage extends StatefulWidget {
   bool isShowAnalytics = true;
   QuestionListPage({super.key, required this.isShowAnalytics});

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  final QuestionController controller = Get.put(QuestionController());
  final SubjectListController sectionController = Get.put(SubjectListController());
  final ScrollController _scrollController = ScrollController();

  final Map<int, bool> _showCorrectMap = {};
  final Map<int, bool> _analyticsMap = {};
  final Map<int, bool> _favoriteMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoading.value &&
          controller.page.value < controller.totalPages.value) {
        controller.loadNextPage();
      }
    });
  }

  void toggleShowCorrect(int id) =>
      setState(() => _showCorrectMap[id] = !(_showCorrectMap[id] ?? false));
  void toggleAnalytics(int id) =>
      setState(() => _analyticsMap[id] = !(_analyticsMap[id] ?? false));


  @override
  Widget build(BuildContext context) {
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
        child: CircularProgressIndicator(
          color: Colors.grey[100],
        ),
      );
    }

    // Dropdown items
    final dropdownItems = <DropdownMenuItem<String>>[
      const DropdownMenuItem(
        value: '', // default "All"
        child: Text("All", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      ...sectionController.sections.map((section) {
        return DropdownMenuItem<String>(
          value: section.id.toString(),
          child: Text(section.name),
        );
      }),
    ];

    // Default value
    String selectedValue = sectionController.selectedSectionId.value == 0
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
        icon: const Icon(Icons.arrow_drop_down_rounded, size: 26, color: Colors.grey),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.list_alt_rounded,
              color: Get.theme.colorScheme.onPrimary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            sectionController.selectSection(value == '' ? 0 : int.parse(value));
            controller.reloadForSection();
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
                  if (index == controller.questions.length) {
                    return controller.page.value < controller.totalPages.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }

                  final question = controller.questions[index];
                  final showCorrect = _showCorrectMap[question.id] ?? false;
                  final showAnalytics = _analyticsMap[question.id] ?? false;
                  final isFavorite = _favoriteMap[question.id] ?? false;

                  return QuestionCard(
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

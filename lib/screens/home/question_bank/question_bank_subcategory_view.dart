import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_subcategory_controller.dart';
import 'package:mcq_mentor/screens/home/question_bank/question_bank_question_list.dart';

class QuestionBankSubCategoryView extends StatelessWidget {
  final int categoryId;
  const QuestionBankSubCategoryView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionBankSubCategoryController());

    controller.fetchSubCategories(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Question Bank Sub Categories"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.subCategories.isEmpty) {
          return const Center(child: Text("No subcategories found."));
        }

        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.subCategories.length +
              (controller.isMoreLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.subCategories.length) {
              /// Show bottom loader while loading next page
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final subCategory = controller.subCategories[index];
            final firstLetter = subCategory.name.isNotEmpty
                ? subCategory.name.characters.first.toUpperCase()
                : '?';

            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      Get.theme.colorScheme.onPrimary.withOpacity(0.1),
                  child: Text(
                    firstLetter,
                    style: TextStyle(
                      color: Get.theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(subCategory.name),
                // subtitle: Text("Status: ${subCategory.status}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                 Get.to(()=> QuestionBankQuestionList(
                  categoryId: subCategory.categoryId,
                  subCategoryId: subCategory.id,
                 ));
                },
              ),
            );
          },
        );
      }),
    );
  }
}

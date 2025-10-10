import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_category_controller.dart';
import 'package:mcq_mentor/screens/home/question_bank/question_bank_subcategory_view.dart';

class AllQuestionBankCategoryView extends StatelessWidget {
  const AllQuestionBankCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionBankCategoryController());

    // Only fetch first page if categories are empty
    if (controller.categories.isEmpty && !controller.isLoading.value) {
      controller.fetchCategories();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Question Bank Categories"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.categories.isEmpty) {
          return  Center(child: Text("No categories found.", style: TextStyle(color: Get.theme.colorScheme.onPrimary,),));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!controller.isMoreLoading.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 150 &&
                controller.currentPage.value < controller.totalPage.value) {
              controller.fetchMoreCategories();
              return true;
            }
            return false;
          },
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.categories.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.categories.length) {
                // Show loader at bottom while fetching next page
                return  Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,)),
                );
              }

              final category = controller.categories[index];
              final firstLetter = category.name.isNotEmpty
                  ? category.name.characters.first.toUpperCase()
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
                  title: Text(category.name),
                  subtitle: Text("Status: ${category.status}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                      Get.to(()=> QuestionBankSubCategoryView(categoryId: category.id));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

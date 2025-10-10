import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/question_bank/question_bank_category_controller.dart';
import 'package:mcq_mentor/screens/home/question_bank/all_questionbank_view.dart';
import 'package:mcq_mentor/screens/home/question_bank/question_bank_subcategory_view.dart';

/// Question Bank Section View (ListTile-style Grid)
class QuestionBankSectionView extends StatelessWidget {
  const QuestionBankSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionBankCategoryController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories available"));
        }

        final itemCount = controller.categories.length > 6
            ? 6
            : controller.categories.length;

        return Column(
          children: [
            /// ✅ Show max 4 category cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: itemCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                final firstLetter = category.name.isNotEmpty
                    ? category.name.characters.first.toUpperCase()
                    : '?';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                   Get.to(()=> QuestionBankSubCategoryView(categoryId: category.id));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                Get.theme.colorScheme.onPrimary.withOpacity(0.1),
                            child: Text(
                              firstLetter,
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            /// ✅ See All Button
            if (controller.categories.length > 6)
              SizedBox(
                width: 180,
                height: 45,
                child: ElevatedButton(
                  onPressed: (){Get.to(()=> AllQuestionBankCategoryView());},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Show More",
                    style: TextStyle(
                      color: Get.theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

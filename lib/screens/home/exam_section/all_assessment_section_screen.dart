import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/colors.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/controller/exam_scction/single_exam_section_controller.dart';
import 'package:mcq_mentor/screens/home/category_section/category_section_list_screen.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';
import 'assessment_section_view.dart';

class AllAssessmentScreen extends StatelessWidget {
  const AllAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AssessmentController());
    final SingleExamSectionController singleExamSectionController = Get.put(
      SingleExamSectionController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Assessment Sections"),
        centerTitle: true,
        backgroundColor: AppColorsDark.primary,
        foregroundColor: AppColorsDark.onPrimary,
      ),
      body: Obx(() {
        if (controller.examSections.isEmpty && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.all(12),
          itemCount:
              controller.examSections.length +
              (controller.hasNextPage.value ? 1 : 0), // Extra item for loader
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < controller.examSections.length) {
              final section = controller.examSections[index];
              final isLive = section.live ?? false;

              return Bounceable(
                onTap: () async {
                  // Show loader
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  // singleExamSectionController.examId = section.id.toString();
                  // Fetch exam section data
                  await singleExamSectionController.fetchExamSections(
                    section.id.toString(),
                  );

                  // Close loader
                  if (Get.isDialogOpen!) {
                    Get.back();
                  }

                  // Navigate based on API response
                  if (singleExamSectionController
                          .examSections
                          .value
                          ?.category ==
                      false) {
                    Get.to(
                      () => WeeklyModelTestScreen(
                        pdf:
                            singleExamSectionController.examSections.value!.pdf,
                        examCategoryId: '',
                        examSectionId: section.id.toString(),
                        title: section.name.toString(),
                        description: section.description.toString(),
                      ),
                    );
                  } else {
                    Get.to(
                      () =>
                          CategorySectionListScreen(examSectionId: section.id!),
                    );
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (section.icon != null)
                              Image.network(section.icon!, height: 30.h),
                            const SizedBox(height: 10),
                            Text(
                              section.name ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isLive ? "Live" : "Offline",
                              style: TextStyle(
                                fontSize: 14,
                                color: isLive ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLive)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedLiveDot(),
                        ),
                    ],
                  ),
                ),
              );
            } else {
              // Loader item at the bottom
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }),
    );
  }
}

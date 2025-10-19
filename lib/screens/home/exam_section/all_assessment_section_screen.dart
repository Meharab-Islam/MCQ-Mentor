import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/colors.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/controller/exam_scction/single_exam_section_controller.dart';
import 'package:mcq_mentor/screens/home/category_section/category_section_list_screen.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';

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
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
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
                     Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,)),
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
                              CachedNetworkImage(
                                imageUrl: section.icon != null
                                    ? section.icon.toString()
                                    : 'https://cdn-icons-png.flaticon.com/128/739/739249.png',
                                height: 30.h,

                                fit: BoxFit.cover,

                                // While loading
                                placeholder: (context, url) => Container(
                                  height: 150.h,
                                  width: 120.w,
                                  alignment: Alignment.center,
                                  color: Colors.grey.shade200,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Get.theme.colorScheme.onPrimary,
                                  ),
                                ),

                                // On error
                                errorWidget: (context, url, error) => Container(
                                  height: 150.h,
                                  width: 120.w,
                                  alignment: Alignment.center,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.w),
                              child: Text(
                                section.name ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 6),
                            // Text(
                            //   isLive ? "Live" : "Offline",
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: isLive ? Colors.green : Colors.red,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      if (isLive)
                        Positioned(
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
              return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary));
            }
          },
        );
      }),
    );
  }
}

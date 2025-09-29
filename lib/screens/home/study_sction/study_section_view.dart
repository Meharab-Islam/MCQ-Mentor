
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/study_section/study_section.dart';

/// Study Section View (Grid of ListTile-like Cards)
class StudySectionView extends StatelessWidget {
  const StudySectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudyController());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.sections.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5, // wider for ListTile look
          ),
          itemBuilder: (context, index) {
            final section = controller.sections[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  // Handle tap for each study section
                  Get.snackbar(
                    "Tapped",
                    section["name"],
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Icon(
                        section["icon"],
                        size: 25,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          section["name"],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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
        );
      }),
    );
  }
}

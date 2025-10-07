import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/controller/exam_scction/single_exam_section_controller.dart';
import 'package:mcq_mentor/screens/home/category_section/category_section_list_screen.dart';
import 'package:mcq_mentor/screens/home/exam_section/all_assessment_section_screen.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';

/// Assessment Section View
class AssessmentSectionView extends StatelessWidget {
  const AssessmentSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AssessmentController());
        final SingleExamSectionController singleExamSectionController = Get.put(SingleExamSectionController());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Assessment Sections",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              TextButton(onPressed: (){
                Get.to(()=> AllAssessmentScreen());
              }, child: Text("See More", style: TextStyle(color: Get.theme.colorScheme.onPrimary, decoration: TextDecoration.underline),))
            ],
          ),
          const SizedBox(height: 10),

          /// 👇 GridView
         Obx(() {
  final itemCount = controller.examSections.length > 4 ? 4 : controller.examSections.length;

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: itemCount, // 👈 max 4 items
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
    ),
    itemBuilder: (context, index) {
      final section = controller.examSections[index];
      final isLive = section.live as bool;

       return Bounceable(
    onTap: () async {
      // Show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Fetch exam section data
      await singleExamSectionController.fetchExamSections(section.id.toString());
      //  singleExamSectionController.examId=section.id.toString();

      // Close loader
      if (Get.isDialogOpen!) {
        Get.back();
      }

      // Navigate based on API response
      if (singleExamSectionController.examSections.value?.category == false) {
        Get.to(() => WeeklyModelTestScreen(
          pdf: singleExamSectionController.examSections.value!.pdf,
           examCategoryId: '',
          examSectionId: section.id.toString(),
           title: section.name.toString(),
          description: section.description.toString(),
        ));
      } else {
        Get.to(() => CategorySectionListScreen(
            examSectionId: section.id!,
            ));
      }
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Stack(
        children: [
          /// Card content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (section.icon != null)
                  Image.network(section.icon.toString(), height: 30.h),
                const SizedBox(height: 10),
                Text(
                  section.name.toString(),
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

          /// Live dot
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
    },
  );
})

        ],
      ),
    );
  }
}

/// Animated pulsing + glowing green dot
class AnimatedLiveDot extends StatefulWidget {
  const AnimatedLiveDot({super.key});

  @override
  State<AnimatedLiveDot> createState() => AnimatedLiveDotState();
}

class AnimatedLiveDotState extends State<AnimatedLiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 8, end: 14).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}

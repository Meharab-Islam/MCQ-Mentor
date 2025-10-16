import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/exam_scction/exam_section_controller.dart';
import 'package:mcq_mentor/controller/exam_scction/single_exam_section_controller.dart';
import 'package:mcq_mentor/screens/home/category_section/category_section_list_screen.dart';
import 'package:mcq_mentor/screens/home/exam_section/all_assessment_section_screen.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';

class AssessmentSectionView extends StatefulWidget {
  const AssessmentSectionView({super.key});

  @override
  State<AssessmentSectionView> createState() => _AssessmentSectionViewState();
}

class _AssessmentSectionViewState extends State<AssessmentSectionView>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Small delay to avoid instant pop-in
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AssessmentController controller = Get.put(AssessmentController());
    final SingleExamSectionController singleExamSectionController =
        Get.put(SingleExamSectionController());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary));
        }

        if (!_showContent) {
          return const SizedBox.shrink(); // hide instantly
        }

        if (controller.examSections.isEmpty) {
          return const Center(child: Text("No Exam Sections Found"));
        }

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _showContent ? 1 : 0,
          child: Column(
            children: [
              _buildSectionGrid(controller, singleExamSectionController),
              Gap(20.h),
              if (controller.examSections.length > 4) _buildShowMoreButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionGrid(
    AssessmentController controller,
    SingleExamSectionController singleExamSectionController,
  ) {
    final itemCount = controller.examSections.length.clamp(0, 4);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final section = controller.examSections[index];
        return _buildSectionCard(section, singleExamSectionController);
      },
    );
  }

  Widget _buildSectionCard(
    dynamic section,
    SingleExamSectionController singleExamSectionController,
  ) {
    final bool isLive = section.live as bool? ?? false;

    return Bounceable(
      onTap: () async {
        Get.dialog(
           Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary)),
          barrierDismissible: false,
        );

        await singleExamSectionController.fetchExamSections(section.id.toString());

        if (Get.isDialogOpen ?? false) Get.back();

        if (singleExamSectionController.examSections.value?.category == false) {
          Get.to(
            () => WeeklyModelTestScreen(
              pdf: singleExamSectionController.examSections.value!.pdf,
              examCategoryId: '',
              examSectionId: section.id.toString(),
              title: section.name.toString(),
              description: section.description.toString(),
            ),
          );
        } else {
          Get.to(() => CategorySectionListScreen(examSectionId: section.id!));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Stack(
          children: [
            _buildCardContent(section, isLive),
            if (isLive)
              const Positioned(
                top: 8,
                right: 8,
                child: FadeInLiveDot(), // fade in live dot
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(dynamic section, bool isLive) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (section.icon != null)
            CachedNetworkImage(
              imageUrl: section.icon ?? '',
              height: 30.h,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildImagePlaceholder(),
              errorWidget: (context, url, error) => _buildImageError(),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              section.name.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 150.h,
      width: 120.w,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Get.theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 150.h,
      width: 120.w,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image_outlined, color: Colors.redAccent, size: 40),
    );
  }

  Widget _buildShowMoreButton() {
    return Center(
      child: SizedBox(
        width: 180,
        height: 45,
        child: ElevatedButton(
          onPressed: () => Get.to(() => AllAssessmentScreen()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    );
  }
}

/// Fading Live Dot
class FadeInLiveDot extends StatefulWidget {
  const FadeInLiveDot({super.key});

  @override
  State<FadeInLiveDot> createState() => _FadeInLiveDotState();
}

class _FadeInLiveDotState extends State<FadeInLiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 8, end: 14).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      builder: (_, __) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: Container(
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
          ),
        );
      },
    );
  }
}

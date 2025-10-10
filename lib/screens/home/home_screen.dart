// ignore_for_file: unused_element

import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/controller/exam/todays_activities_controller.dart';
import 'package:mcq_mentor/screens/home/exam_section/assessment_section_view.dart';
import 'package:mcq_mentor/screens/home/exam_section/quiz_card.dart';
import 'package:mcq_mentor/screens/home/question_bank/question_bank_section.dart';
import 'package:mcq_mentor/screens/home/study_sction/study_section_view.dart';
import 'package:mcq_mentor/screens/packages/package_list_screen.dart';
import 'package:mcq_mentor/widget/under_maintance_screen.dart';

// -------------------- HOME SCREEN --------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static bool _dialogShown = false;
  final activityController = Get.put(TodaysActivitiesController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dialogShown) {
        _showInfoDialog();
        _dialogShown = true;
      }
    });
  }

  void _showInfoDialog() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sound/welcome_sound.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundImage: AssetImage(AppImages.logo),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "স্বাগতম MCQ Mentor এ! 🎓",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "👉 এখানে আপনি অ্যাসেসমেন্ট দিতে পারবেন, স্টাডি ম্যাটেরিয়াল পড়তে পারবেন এবং মাল্টিপ্লেয়ার কুইজ গেম খেলতে পারবেন।\n\n"
                  "💡 আপনার সক্রিয় প্যাকেজ চেক করুন এবং শেখার আনন্দ উপভোগ করুন!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "বুঝেছি",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5.h),
              FadeInDown(child: _buildWarningBanner()),
              Gap(15.h),

              FadeInLeft(child: _buildSectionHeader('Assessment Section')),
              Gap(10.h),
              const AssessmentSectionView(),

              FadeInLeft(child: _buildSectionHeader('Question Bank')),
              Gap(10.h),
              const QuestionBankSectionView(),

              Gap(20.h),
              FadeInLeft(child: _buildSectionHeader('Study Section')),
              Gap(10.h),
              const StudySectionView(),
              Gap(20.h),

              FadeInUp(child: _buildMultiplayerBanner()),
              Gap(20.h),

              FadeInDown(
                child: Text(
                  'Today\'s Activities',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap(10.h),
              FadeInDown(child: _buildActivitiesCard()),
              Gap(20.h),

              // ✅ Dynamic List of Today's Exams
              Obx(() {
                if (activityController.isLoading.value &&
                    activityController.todaysExams.isEmpty) {
                  return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
                }

                if (activityController.todaysExams.isEmpty) {
                  return Center(
                    child: Text(
                      'No exams available today',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activityController.todaysExams.length,
                  itemBuilder: (context, index) {
                    final exam = activityController.todaysExams[index];
                    return FadeInLeft(
                      child: QuizCard(
                        id: exam.id,
                        examName: exam.examName,
                        examDescription: exam.examDescription,
                        examDate: exam.examDate,
                        durationMinutes: int.parse(exam.duration),
                        totalMark: exam.totalMark.toString(),
                        submitted: exam.submitted,
                      ),
                    );
                  },
                );
              }),
              // Gap(100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.red.shade700, size: 24.sp),
          Gap(8.w),
          Expanded(
            child: Text(
              'আপনার Active প্যাকেজ নেই।',
              style: TextStyle(color: Colors.red.shade700, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.to(() => PackageListScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'প্যাকেজ কিনুন',
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMultiplayerBanner() {
    return Bounceable(
      onTap: () => Get.to(() => UnderMaintanceScreen()),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.videogame_asset, color: Colors.white, size: 24.sp),
              Gap(8.w),
              Text(
                'Play Multiplayer Quiz Game',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Gap(8.w),
              Icon(Icons.star, color: Colors.yellow, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesCard() {
    return Obx(() {
      if (activityController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildActivityRow(
                title1: 'Total Live Exams:',
                value1: '${activityController.totalExams.value}',
                title2: 'Remaining:',
                value2: '${activityController.remainingExams.value}',
              ),
              Gap(8.h),
              _buildActivityRow(
                title1: 'Total Marks:',
                value1: '${activityController.totalMarks.value}',
                title2: 'Total Duration:',
                value2: "${activityController.totalDuration.value}",
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActivityRow({
    required String title1,
    required String value1,
    String? title2,
    String? value2,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: title1,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            children: [
              TextSpan(
                text: ' $value1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ),
        if (title2 != null && value2 != null)
          RichText(
            text: TextSpan(
              text: title2,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              children: [
                TextSpan(
                  text: ' $value2',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/screens/home/exam_section/assessment_section_view.dart';
import 'package:mcq_mentor/screens/home/exam_section/quiz_card.dart';
import 'package:mcq_mentor/screens/home/study_sction/study_section_view.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart'; // Assumed from your code
import 'package:mcq_mentor/widget/custom_drawer.dart'; // Assumed from your code

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppbar(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5.h),
              // Warning Banner
              FadeInDown(child: _buildWarningBanner()),
              Gap(15.h),

              // Exam Section
              FadeInLeft(
                child: _buildSectionHeader(context, 'Assessment Section'),
              ),
              Gap(10.h),
              const AssessmentSectionView(),
              Gap(20.h),

              // Study Section
              FadeInLeft(
                child: _buildSectionHeader(context, 'Study Section'),
              ),
              Gap(10.h),
              const StudySectionView(),
              Gap(20.h),

              // Multiplayer Banner
              FadeInUp(child: _buildMultiplayerBanner()),
              Gap(20.h),

              // --- New Sections Added Below ---

              // Today's Activities Section
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
              FadeInDown(
                child: _buildActivitiesCard(),
              ),
              Gap(20.h),

              // Daily Quiz Section
              FadeInLeft(
                child: const QuizCard(
                  title: 'ডেইলি কুইজ',
                  totalMarks: 25,
                  duration: '10 min',
                  subject: 'English Literature',
                  topic: 'Renaissance Period\n[Elizabethan Period, Jacobean ... Show More',
                  studyMaterialsCount: 4,
                ),
              ),
              Gap(20.h),

              // Bcs Final Exam Section
              FadeInLeft(
                child: const QuizCard(
                  title: '৪৭তম বিসিএস ফাইনাল মডেল টেস্ট ও রিভিশন',
                  totalMarks: 200,
                  duration: '1h 30m',
                  subject: '"Award Mania: Season - 14" এর জন্য প্রযোজ্য',
                  topic: '৪৭তম বিসিএস ফাইনাল মডেল টেস্ট — ১৫\n(রিয়েল টাইম পরীক্ষা: সকাল ১০:০০ – ১০:... Show More',
                  studyMaterialsCount: 1,
                ),
              ),
              Gap(100.h),
            ],
          ),
        ),
      ),
    );
  }

  // Warning Banner, Section Header, and Multiplayer Banner methods remain the same as your code.
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
            onPressed: () {},
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

  Widget _buildSectionHeader(BuildContext context, String title) {
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
    return Container(
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
    );
  }

  // --- New Methods to be added to HomeScreen Class ---

  Widget _buildActivitiesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildActivityRow(
              title1: 'Total Live Exams:',
              value1: '15',
              title2: 'Remaining:',
              value2: '15',
            ),
            Gap(8.h),
            _buildActivityRow(
              title1: 'Total Marks:',
              value1: '795',
              title2: 'Total Duration:',
              value2: '6h 28m',
            ),
            Gap(8.h),
            _buildActivityRow(
              title1: 'Total Live Class:',
              value1: '0',
            ),
          ],
        ),
      ),
    );
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
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
            ),
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
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
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
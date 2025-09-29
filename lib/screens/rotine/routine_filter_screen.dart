import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart'; // Assumed from your code
import 'package:mcq_mentor/widget/custom_drawer.dart'; // Assumed from your code

class RoutineFilterScreen extends StatefulWidget {
  const RoutineFilterScreen({super.key});

  @override
  State<RoutineFilterScreen> createState() => _RoutineFilterScreenState();
}

class _RoutineFilterScreenState extends State<RoutineFilterScreen> {
  // A list to manage the state of the checkboxes
  final List<String> filterOptions = [
    'সকল বাটন',
    '৪৭তম বিসিএস প্রস্তুতি',
    'সাবজেক্ট কেয়ার',
    'ব্যাংক নিয়োগ প্রস্তুতি',
    'শিক্ষক নিয়োগ ও নিবন্ধন',
    'জব সল্যুশন',
    'হ্ম-১০তম গ্রেডের প্রস্তুতি',
    'নতুনদের বিসিএস প্রস্তুতি'
  ];

  final Map<String, bool> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    for (var option in filterOptions) {
      selectedFilters[option] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Gap(10.h),
            // Go to Date and Filter By row
            FadeInDown(child: _buildHeaderRow()),
            Gap(16.h),
            
            // The content from the "Today's Activities" screen is shown here
            // This is just for UI representation, you'll manage data dynamically.
            FadeInLeft(
              child: _buildRoutineCard(
                date: 'Tuesday, 16 Sep, 2025',
                isLive: true,
                title: 'ডেইলি কুইজ',
                totalMarks: 25,
                duration: '10 minutes',
                subject: 'English Literature',
                topic: 'Topic - Rennaiisance Period [Elizabethan Period, Jacobean P... Show More',
              ),
            ),
            Gap(16.h),
            FadeInLeft(
              child: _buildRoutineCard(
                date: 'Tuesday, 16 Sep, 2025',
                isLive: true,
                title: '৪৭তম বিসিএস ফাইনাল মডেল টেস্ট ও রিভিশন',
                totalMarks: 200,
                duration: '01 hr 30 mins',
                subject: '"Award Mania: Season - 14" এর জন্য প্রযোজ্য',
                topic: '৪৭তম বিসিএস ফাইনাল মডেল টেস্ট — ১৪ (রিয়েল টাইম পরীক্ষা: সকাল ১০:০০ – ১০:...',
              ),
            ),
             Gap(16.h),
             FadeInLeft(
              child: _buildRoutineCard(
                date: 'Tuesday, 16 Sep, 2025',
                isLive: true,
                title: 'প্রাইমারি ডেইলি কুইজ',
                totalMarks: 20,
                duration: '10 mins',
                subject: 'General Knowledge',
                topic: 'Topic - Daily Quiz',
              ),
            ),
          ],
        ),
      ),
     
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            Gap(5.w),
            Text(
              'Go to date',
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Filter by',
              style: TextStyle(fontSize: 16.sp, color: Colors.blue),
            ),
            Gap(5.w),
            const Icon(Icons.filter_alt, color: Colors.blue),
          ],
        ),
      ],
    );
  }

  Widget _buildRoutineCard({
    required String date,
    required bool isLive,
    required String title,
    required int totalMarks,
    required String duration,
    required String subject,
    required String topic,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                if (isLive)
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 10.sp),
                      Gap(4.w),
                      Text('Live', style: TextStyle(fontSize: 14.sp, color: Colors.red)),
                    ],
                  ),
              ],
            ),
            Gap(8.h),
            Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            Gap(4.h),
            Row(
              children: [
                Text('Total marks: $totalMarks', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                Gap(10.w),
                Text('Duration: $duration', style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
              ],
            ),
            Gap(10.h),
            Text('Subject - $subject', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            Gap(4.h),
            Text('Topic - $topic', style: TextStyle(fontSize: 14.sp)),
            Gap(16.h),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.menu_book, size: 20.sp),
              label: Text('Study materials'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade800,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
            ),
            Gap(16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue.shade700, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('প্র্যাকটিস কুইজ', style: TextStyle(color: Colors.blue.shade700)),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text('লাইভ পরীক্ষা দিন', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
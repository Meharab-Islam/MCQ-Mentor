import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final int totalMarks;
  final String duration;
  final String subject;
  final String topic;
  final int studyMaterialsCount;

  const QuizCard({
    super.key,
    required this.title,
    required this.totalMarks,
    required this.duration,
    required this.subject,
    required this.topic,
    required this.studyMaterialsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Details Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    // No maxLines or overflow properties, so it will wrap
                  ),
                ),
                Gap(8.w),
                Text(
                  'Duration: $duration',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Gap(4.h),
            Text(
              'Total marks: $totalMarks',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            Gap(10.h),
            Text(
              'Subject - $subject',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Gap(4.h),
            Text(
              'Topic - $topic',
              style: TextStyle(
                fontSize: 14.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Gap(16.h),

            // Study Materials Button
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.menu_book, size: 20.sp),
              label: Text(
                'Study materials ($studyMaterialsCount)',
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade800,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            Gap(16.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue.shade700, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'প্র্যাকটিস কুইজ',
                      style: TextStyle(color: Colors.blue.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'লাইভ পরীক্ষা দিন',
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
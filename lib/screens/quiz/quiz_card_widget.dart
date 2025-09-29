import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do

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
    return FadeInUp( // Animate the card as it appears
      child: Card(
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
              // ... (The rest of the QuizCard UI code from the previous response)
              // You can find the complete code in the previous response.
              // Just replace the Row with the title with the new one for wrapping.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
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
              // ... and the rest of the body
              // ...
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
                      onPressed: () {
                        // Navigate to the quiz exam screen
                        Get.toNamed('/exam');
                      },
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
      ),
    );
  }
}
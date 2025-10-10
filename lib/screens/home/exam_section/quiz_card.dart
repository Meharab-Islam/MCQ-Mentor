import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mcq_mentor/screens/exam/exam_details_view.dart';

class QuizCard extends StatefulWidget {
  final int id;
  final String examName;
  final String examDescription;
  final String examDate; // yyyy-MM-dd
  final int durationMinutes;
  final String totalMark;
  final bool submitted;

  const QuizCard({
    super.key,
    required this.id,
    required this.examName,
    required this.examDescription,
    required this.examDate,
    required this.durationMinutes,
    required this.totalMark,
    this.submitted = false,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  bool isExpanded = false;

  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day}-${parsed.month}-${parsed.year}';
    } catch (_) {
      return date;
    }
  }

  String formatDuration(int minutes) {
    if (minutes <= 0) return '0 min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return hours > 0 ? '${hours}h ${mins}m' : '${mins} min';
  }

  String _removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return html_parser.parse(document.body?.text ?? '').documentElement?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final plainDescription = _removeHtmlTags(widget.examDescription);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam Name & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.examName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  formatDate(widget.examDate),
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            Gap(8.h),

            // Total Marks & Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Marks: ${widget.totalMark}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                Text(
                  'Duration: ${formatDuration(widget.durationMinutes)}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
            Gap(12.h),

            // Expandable Description
            if (widget.examDescription.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      plainDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                    ),
                    secondChild: Html(
                      data: widget.examDescription,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.sp),
                          color: Colors.grey[800],
                        ),
                      },
                    ),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        isExpanded ? 'Show Less' : 'Read More',
                        style: TextStyle(
                          color: Get.theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Gap(12.h),
                ],
              ),

            // Live Exam Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.info_outline),
                onPressed: (){
        
                Get.to(()=> ExamDetailsView(examId: widget.id, submitted: widget.submitted,));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                    Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                label: Text(
                  'Details',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

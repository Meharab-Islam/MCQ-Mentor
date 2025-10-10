import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:mcq_mentor/controller/exam/live_exam_controller.dart';
import 'package:mcq_mentor/screens/archive/archive_exam_view.dart';
import 'package:mcq_mentor/screens/exam/exam_details_view.dart';
import 'package:mcq_mentor/screens/rotine/all_routine_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class WeeklyModelTestScreen extends StatelessWidget {
  final String title;
  final String description;
  final String examSectionId;
  final String examCategoryId;
  final bool pdf;

  const WeeklyModelTestScreen({
    super.key,
    required this.description,
    required this.title,
    required this.examSectionId,
    required this.examCategoryId,
    required this.pdf,
  });

  @override
  Widget build(BuildContext context) {
    final LiveExamController liveExamController = Get.put(LiveExamController());
    liveExamController.fetchLiveExams(
      examSectionId: examSectionId,
      examCategoryId: examCategoryId, // optional
    );

    

    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title + Info
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(Icons.info, size: 20.sp),
                ],
              ),
              Gap(8.h),

              /// Description
              if (description.isNotEmpty && description != 'null')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(150),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Html(data: description),
                ),

              Gap(15.h),

              /// Live Exams List below description
              Obx(() {
                if (liveExamController.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
                }

                if (liveExamController.liveExams.isEmpty) {
                  return SizedBox();
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: liveExamController.liveExams.length,
                  separatorBuilder: (_, __) => Gap(10.h),
                  itemBuilder: (context, index) {
                    final exam = liveExamController.liveExams[index];
                    return _examCard(context, exam, );
                  },
                );
              }),

              Gap(15.h),

              /// Wrap for exam items (routine, result, archive...)
              Wrap(
                runSpacing: 10.h,
                spacing: 10.w,
                children: [
                  itemCard(
                    context,
                    icon: Icons.rule_outlined,
                    title: 'Routine',
                    onTap: () {
                      Get.to(
                        () => AllRoutineScreen(
                          examSectionId: examSectionId,
                          examCategoryId: examCategoryId,
                        ),
                      );
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.verified_outlined,
                    title: 'Result',
                  ),
                  itemCard(
                    context,
                    icon: Icons.archive_outlined,
                    title: 'Archive',
                    onTap: () {
                      Get.to(() => ArchiveExamView(
                        examSectionId: int.parse(examSectionId),
                        examCategoryId: int.parse(examCategoryId),
                      ));
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Favorite',
                  ),
                  itemCard(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'Syllabus',
                  ),
                  itemCard(
                    context,
                    icon: Icons.merge_outlined,
                    title: 'Merit List',
                  ),
                  pdf
                      ? itemCard(
                          context,
                          icon: Icons.picture_as_pdf_outlined,
                          title: 'PDFs',
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Exam card for each live exam
Widget _examCard(BuildContext context, dynamic exam) {

    String formatDate(String? date) {
    if (date == null) return '—';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (_) {
      return date;
    }
  }

  String formatDuration(int? minutes) {
    if (minutes == null || minutes <= 0) return '0 min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins} min';
  }

  return Card(
    elevation: 5,
    margin: EdgeInsets.symmetric(vertical: 10.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.r),
    ),
    shadowColor: Get.theme.colorScheme.onPrimary.withOpacity(0.2),
    child: Padding(
      padding: EdgeInsets.all(18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Created date
          // Text(
          //   'Created: ${formatDate(exam.ex)}',
          //   style: TextStyle(
          //     fontSize: 12.sp,
          //     color: Colors.grey[600],
          //     fontStyle: FontStyle.italic,
          //   ),
          // ),
          SizedBox(height: 6.h),

          // Exam Title
          Text(
            exam.examName,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),

          // Expandable Description
          _ExpandableDescription(description: exam.examDescription),
          SizedBox(height: 12.h),

          // Info Grid: Date & Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('Date', formatDate(exam.examDate)),
              _infoItem('Duration', formatDuration(exam.duration)),
            ],
          ),
          Gap(10.h),
          // Info Grid: Total Marks & Cut Marks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('Total Marks', '${exam.totalMarks}'),
              _infoItem('Cut Marks', '${exam.cutMarks}'),
            ],
          ),
          SizedBox(height: 12.h),

          // Details Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.to(() => ExamDetailsView(examId: exam.id, submitted: exam.submitted,));
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Info Item Widget
Widget _infoItem(String label, String value) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextSpan(
          text: value,
          style: TextStyle(fontSize: 12.sp, color: Colors.black87),
        ),
      ],
    ),
  );
}

  /// Reusable item card for bottom options
  Widget itemCard(
    BuildContext context, {
    String? iconUrl,
    required String title,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: iconUrl != null && iconUrl.isNotEmpty
                  ? Image.network(
                      iconUrl,
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Icon(
                      icon ?? Icons.help_outline,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
            ),
            Gap(10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 15.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _ExpandableDescription extends StatefulWidget {
  final String description;
  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool isExpanded = false;

  // ✅ Helper function to remove HTML tags
  String _removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return html_parser.parse(document.body?.text ?? '').documentElement?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final plainText = _removeHtmlTags(widget.description);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            plainText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          secondChild: Html(
            data: widget.description,
            style: {
              "body": Style(
                fontSize: FontSize(14.sp),
                color: Colors.grey[800],
              ),
            },
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
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
      ],
    );
  }}
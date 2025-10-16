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
import 'package:mcq_mentor/screens/archive/result_for_archive_view.dart';
import 'package:mcq_mentor/screens/exam/exam_details_view.dart';
import 'package:mcq_mentor/screens/favorite/favorite_list_screen.dart';
import 'package:mcq_mentor/screens/rotine/all_routine_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:mcq_mentor/widget/under_maintance_screen.dart';

class WeeklyModelTestScreen extends StatefulWidget {
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
  State<WeeklyModelTestScreen> createState() => _WeeklyModelTestScreenState();
}

class _WeeklyModelTestScreenState extends State<WeeklyModelTestScreen> {
  final LiveExamController liveExamController = Get.put(LiveExamController());

  @override
  void initState() {
    super.initState();
    // ✅ Fetch data once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      liveExamController.fetchLiveExams(
        examSectionId: widget.examSectionId,
        examCategoryId: widget.examCategoryId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🧭 Title + Info Icon
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
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

              /// 📄 Description
              if (widget.description.isNotEmpty && widget.description != 'null')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(150),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Html(data: widget.description),
                ),

              Gap(15.h),

              /// 📚 Live Exams List
              Obx(() {
                if (liveExamController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  );
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
                    return _examCard(context, exam);
                  },
                );
              }),

              Gap(15.h),

              /// 🧩 Bottom Feature Buttons
              Wrap(
                runSpacing: 10.h,
                spacing: 10.w,
                children: [
                  itemCard(
                    context,
                    icon: Icons.rule_outlined,
                    title: 'Routine',
                    onTap: () {
                      Get.to(() => AllRoutineScreen(
                            examSectionId: widget.examSectionId,
                            examCategoryId: widget.examCategoryId,
                          ));
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.verified_outlined,
                    title: 'Result',
                    onTap: () {
                      Get.to(()=> ResultForArchiveView(examSectionId: widget.examSectionId, examCategoryId: widget.examCategoryId,));
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.archive_outlined,
                    title: 'Archive',
                    onTap: () {
                      Get.to(() => ArchiveExamView(
                            examSectionId: int.parse(widget.examSectionId),
                            examCategoryId: int.parse(widget.examCategoryId),
                          ));
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.favorite_border,
                    title: 'Favorite',
                    onTap: () {
                      Get.to(() => const FavoriteListScreen());
                    },
                  ),
                  itemCard(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: 'Syllabus',
                    onTap: (){
                      Get.to(()=> UnderMaintanceScreen());
                    }
                  ),
                  itemCard(
                    context,
                    icon: Icons.merge_outlined,
                    title: 'Merit List',
                      onTap: (){
                      Get.to(()=> UnderMaintanceScreen());
                    }
                  ),
                  widget.pdf
                      ? itemCard(
                          context,
                          icon: Icons.picture_as_pdf_outlined,
                          title: 'PDFs',
                            onTap: (){
                      Get.to(()=> UnderMaintanceScreen());
                    }
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🧾 Exam Card for Each Live Exam
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

    String formatDuration(dynamic minutes) {
      if (minutes == null) return '0 min';
      final int totalMinutes = int.tryParse(minutes.toString()) ?? 0;
      if (totalMinutes <= 0) return '0 min';
      final hours = totalMinutes ~/ 60;
      final mins = totalMinutes % 60;
      return hours > 0 ? '${hours}h ${mins}m' : '${mins} min';
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
            /// 🧾 Exam Title
            Text(
              exam.examName ?? 'Untitled Exam',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Gap(8.h),

            /// 📜 Description (HTML Safe)
            Html(
              data: exam.examDescription ?? '',
              style: {
                "p": Style(
                  fontSize: FontSize(14.sp),
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  color: Colors.grey.shade800,
                ),
              },
            ),

            Gap(12.h),

            /// 📅 Date & Duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem('Date', formatDate(exam.examDate)),
                _infoItem('Duration', formatDuration(exam.duration)),
              ],
            ),

            Gap(10.h),

            /// 📊 Marks Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem('Total Marks', '${exam.totalMarks ?? 0}'),
                _infoItem('Cut Marks', '${exam.cutMarks ?? 0}'),
              ],
            ),

            Gap(14.h),

            /// 🎯 Details Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => ExamDetailsView(
                        examId: exam.id,
                        submitted: exam.submitted,
                      ));
                },
                icon: Icon(
                  Icons.info_outline,
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                ),
                label: Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.onPrimary,
                  foregroundColor:
                      Get.isDarkMode ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ℹ️ Info Item Widget
  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// 🧩 Bottom Menu Card
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
                      errorBuilder: (_, __, ___) => Icon(
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

/// 🌐 Expandable Description Widget (reusable)
class _ExpandableDescription extends StatefulWidget {
  final String description;
  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool isExpanded = false;

  String _removeHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    return html_parser
            .parse(document.body?.text ?? '')
            .documentElement
            ?.text ??
        '';
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
      ],
    );
  }
}

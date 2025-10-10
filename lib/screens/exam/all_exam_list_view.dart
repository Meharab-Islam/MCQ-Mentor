import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcq_mentor/controller/exam/all_exam_list_controller.dart';
import 'package:mcq_mentor/screens/exam/exam_details_view.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:html/parser.dart' as html_parser;

class AllExamListView extends StatelessWidget {
  const AllExamListView({super.key});

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

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: const Size(360, 690), minTextAdapt: true);

    final controller = Get.put(AllExamListController());
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !controller.isMoreLoading.value &&
          controller.currentPage < controller.totalPage) {
        controller.loadNextPage();
      }
    });

    return Scaffold(
      appBar: CustomAppbar(title: 'All Exam List',),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.examList.isEmpty) {
          return const Center(
              child: Text(
            'No exams found',
            style: TextStyle(fontSize: 16),
          ));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchAllExams(),
          child: ListView.builder(
            controller: scrollController,
            itemCount: controller.examList.length +
                (controller.isMoreLoading.value ? 1 : 0),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            itemBuilder: (context, index) {
              if (index < controller.examList.length) {
                final exam = controller.examList[index];
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
                        // Created date at top
                        Text(
                          'Created: ${formatDate(exam.createdAt)}',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 6.h),

                        // Title
                        Text(
                          exam.examName,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // Animated Expandable Description
                        _ExpandableDescription(description: exam.examDescription),

                        SizedBox(height: 12.h),

                        // Info 2x2 Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 
                          children: [
                            _infoItem('Date', formatDate(exam.examDate)),
                            _infoItem('Duration', formatDuration(exam.duration)),
                            
                          ],
                        ),
                        Gap(10.h),
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
                            Get.to(()=> ExamDetailsView(examId: exam.id));
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Details'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Loader for next page
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child:  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,)),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget _infoItem(String label, String value) {
    return SizedBox(
      // width: 150.w,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            TextSpan(
              text: value,
              style: TextStyle(fontSize: 12.sp, color: Colors.black87),
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
  }
}
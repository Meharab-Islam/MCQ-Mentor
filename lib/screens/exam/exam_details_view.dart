import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcq_mentor/controller/exam/exam_details_controller.dart';
import 'package:mcq_mentor/controller/pdf/pdf_open_download_controller.dart';
import 'package:mcq_mentor/screens/exam/exam_question_view.dart';
import 'package:mcq_mentor/screens/exam/widget/pdf_viewer_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class ExamDetailsView extends StatelessWidget {
  final int examId;
  final bool submitted;
  const ExamDetailsView({required this.examId, this.submitted = false,super.key});

  String formatDuration(int? minutes) {
    if (minutes == null || minutes <= 0) return '0 min';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) return '${hours}h ${mins}m';
    return '${mins} min';
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    final controller = Get.put(ExamDetailsController(examId));
    final downloadController = Get.put(PdfOpenDownloadController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const CustomAppbar(title: "Exam Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        final exam = controller.examDetails.value;
        if (exam == null) {
          return const Center(child: Text('No data found'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient:  LinearGradient(
                    colors: [Get.theme.colorScheme.onPrimary, Get.theme.colorScheme.onSecondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.examName,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Exam Date: ${exam.examDate ?? '—'}",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 🔹 Info Grid (2x2)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  child: Wrap(
                    runSpacing: 12.h,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      _infoItem(Icons.timer, 'Duration', formatDuration(int.parse(exam.duration.toString()))),
                      _infoItem(Icons.grade, 'Total Marks', '${exam.totalMarks ?? 0}'),
                      _infoItem(Icons.cut, 'Cut Marks', '${exam.cutMarks ?? 0}'),
                      _infoItem(Icons.calendar_today, 'Date', exam.examDate ?? '—'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // 🔹 Description Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Html(
                  data: exam.examDescription,
                  style: {
                    "body": Style(fontSize: FontSize(14.sp), color: Colors.black87),
                  },
                ),
              ),

              SizedBox(height: 20.h),

              // 🔹 PDF Section
              if (exam.pdfs.isNotEmpty) ...[
                Text(
                  '📄 PDFs',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Column(
                  children: exam.pdfs.map((pdf) {
                    final fileName = pdf.split('/').last;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 6.h),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        title: Text(fileName, style: TextStyle(fontSize: 14.sp)),
                        onTap: () => Get.to(() => PDFViewerScreen(pdfUrl: pdf)),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () => downloadController.downloadPdf(pdf, fileName),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.h),
              ],

             submitted == false? Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.colorScheme.onPrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(
                      'Go to Exam',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                     Get.to(()=> ExamQuestionView(examId: examId, duration: int.parse(exam.duration!),));
                    },
                  ),
                ),
              ):Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30.r)
                  ),
                  child: Center(
                    child: Text("Submitted", style: TextStyle(color: Colors.white,fontSize: 17.sp),),
                  ),
                )
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Get.theme.colorScheme.onPrimary, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.black54, fontWeight: FontWeight.w500)),
                Text(value,
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

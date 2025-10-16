import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mcq_mentor/controller/archive/archive_exam_controller.dart';
import 'package:mcq_mentor/model/archive/archive_exam_model.dart';
import 'package:mcq_mentor/screens/archive/archive_give_exam_question_list.dart';
import 'package:mcq_mentor/screens/archive/archive_question_list_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ArchiveExamView extends StatefulWidget {
  final int examSectionId;
  final int examCategoryId;
  
  const ArchiveExamView({super.key, required this.examSectionId, required this.examCategoryId});

  @override
  State<ArchiveExamView> createState() => _ArchiveExamViewState();
}

class _ArchiveExamViewState extends State<ArchiveExamView> {
  final ArchiveExamController controller = Get.put(ArchiveExamController());
  final ScrollController _scrollController = ScrollController();
  

  @override
  void initState() {
    super.initState();
    // Listen for scroll to bottom → load next page
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // Load next page if not already loading
        if (!controller.isLoading.value &&
            controller.currentPage.value < controller.totalPages) {
          controller.fetchArchives(page: controller.currentPage.value + 1, examSectionId: widget.examSectionId, examCategoryId: widget.examCategoryId);
        }
      }
    });
    controller.fetchArchives(examSectionId: widget.examSectionId, examCategoryId: widget.examCategoryId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 Archive Exams"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.exams.isEmpty) {
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary));
        }

        if (controller.exams.isEmpty) {
          return const Center(child: Text("No archives available."));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchArchives(
              page: 1,
              examSectionId: widget.examSectionId,
              examCategoryId: widget.examCategoryId,
            );
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.exams.length +
                (controller.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.exams.length) {
                return  Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary)),
                );
              }

              final ArchiveExamModel exam = controller.exams[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧠 Exam Name
                      Text(
                        exam.examName,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),

                      // 📖 Description
                      Html(data: exam.examDescription),

                      // 📅 Info Row
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _infoChip(Icons.calendar_today, exam.examDate),
                          _infoChip(Icons.timer, "${exam.duration} mins"),
                          _infoChip(Icons.star, "${exam.totalMarks} marks"),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Divider(),

                      // 📄 PDF Section
                      if (exam.pdfs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "📄 Related PDFs",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            ...exam.pdfs.map(
                              (pdf) => ListTile(
                                dense: true,
                                leading: const Icon(Icons.picture_as_pdf,
                                    color: Colors.redAccent),
                                title: Text(
                                  pdf.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  icon:  Icon(Icons.download,
                                      color: Get.theme.colorScheme.onPrimary),
                                  onPressed: () async {
                                    final uri = Uri.parse(pdf);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri,
                                          mode:
                                              LaunchMode.externalApplication);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                      // 🎥 Videos (future)
                      if (exam.videos.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Text(
                          "🎥 Videos:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        ...exam.videos.map((v) => Text(v)),
                      ],

                      const SizedBox(height: 12),

                      // 🔘 Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                             Get.to(()=>ArchiveQuestionListView(isShowAnalytics: false, examSectionSd: widget.examCategoryId.toString(), examSectionCategoryId: widget.examCategoryId.toString(), archiveId: exam.id,) )  ;
                              },
                              icon: Icon(Icons.visibility, color: Get.theme.colorScheme.onPrimary,),
                              label: Text("See Questions", style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                              ),),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                               Get.to(()=> ArchiveGiveExamQuestionList(archiveId: exam.id, duration: int.parse(exam.duration)));
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Give Exam"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Get.theme.colorScheme.onPrimary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Get.theme.colorScheme.onPrimary,
    );
  }
}

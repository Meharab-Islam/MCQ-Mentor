import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/pdf/all_pdf_list_controller.dart';
import 'package:mcq_mentor/controller/pdf/pdf_open_download_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:flutter_html/flutter_html.dart';

class PdfListPage extends StatelessWidget {
  final controller = Get.put(PdfController());
  final pdfController = Get.put(PdfOpenDownloadController());

  String categoryId;
  String examSectionId;

  PdfListPage({super.key, required this.categoryId, required this.examSectionId});

  @override
  Widget build(BuildContext context) {
    controller.fetchPdfList(categoryId, examSectionId);

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.primary,
      appBar: CustomAppbar(
        title: "PDF List",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        if (controller.pdfList.isEmpty) {
          return const Center(
            child: Text(
              'কোনো PDF পাওয়া যায়নি 😔',
              style: TextStyle(fontSize: 16,),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.pdfList.length,
          itemBuilder: (context, index) {
            final pdf = controller.pdfList[index];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                // shadowColor: Colors.black12,
                // color: Get.theme.colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PDF Icon & Name Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              pdf.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Status
                      Html(
                        data: pdf.details,
                        style: {
                          "p": Style(
                            fontSize: FontSize(14),
                            // color: Get.theme.colorScheme.onPrimary,
                            // margin:  EdgeInsets.symmetric(vertical: 4),
                          ),
                        },
                      ),

                      const SizedBox(height: 16),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => pdfController.openPdfInApp(
                              pdf.pdfUrl,
                              pdf.name,
                            ),
                            icon: const Icon(Icons.visibility),
                            label: const Text("View"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                pdfController.downloadPdf(pdf.pdfUrl, pdf.name),
                            icon: const Icon(Icons.download),
                            label: const Text("Download"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                pdfController.openPdfExternal(pdf.pdfUrl),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text("Open"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
          },
        );
      }),
    );
  }
}

/// 🔹 PDF Viewer Page
class PdfViewerPage extends StatelessWidget {
  final String filePath;
  final String title;

  const PdfViewerPage({super.key, required this.filePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
      ),
    );
  }
}

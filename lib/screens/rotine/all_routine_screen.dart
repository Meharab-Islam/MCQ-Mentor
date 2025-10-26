import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/routine/all_routine_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';
import 'package:path/path.dart' as p; // The file path utility
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class AllRoutineScreen extends StatelessWidget {
  final String examSectionId;
  final String examCategoryId;
  const AllRoutineScreen({
    super.key,
    required this.examSectionId,
    required this.examCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AllRoutineController(
        examSectionId: examSectionId,
        examCategoryId: examCategoryId,
      ),
    );

    return Scaffold(
      appBar: CustomAppbar(),
      body: Column(
        children: [
          /// 🔍 Search bar
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              onChanged: (value) => controller.setSearch(value),
              cursorColor: Get.theme.colorScheme.onPrimary,

              decoration: InputDecoration(
                hintText: "Search routine...",
                hintStyle: TextStyle(color: Get.theme.colorScheme.onPrimary),
                prefixIcon: Icon(
                  Icons.search,
                  color: Get.theme.colorScheme.onPrimary,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                ),
                filled: true,
                fillColor: Get.theme.colorScheme.primary,
              ),
            ),
          ),

          /// ✅ List of routines
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.routines.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.onPrimary,
                  ),
                );
              }

              if (controller.routines.isEmpty) {
                return const Center(child: Text("No routines found"));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels >=
                          scrollNotification.metrics.maxScrollExtent - 200 &&
                      !controller.isLoading.value &&
                      controller.pagination.value?.nextPage != null) {
                    controller.fetchRoutines();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  itemCount:
                      controller.routines.length +
                      (controller.pagination.value?.nextPage != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.routines.length) {
                      final routine = controller.routines[index];
                      return RoutineCard(
                        title: routine.name,
                        description: routine.description,
                        date: routine.date,
                        duration: routine.duration,
                        marks: routine.totalMarks,
                        file: routine.file ?? "",
                      );
                    } else {
                      /// Show loader at bottom while fetching next page
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// ✅ Routine card widget
class RoutineCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String file;
  final String duration; // in minutes from API
  final String marks;

  const RoutineCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.file,
    required this.marks,
  });

  /// Convert minutes -> "Xh Ym"
  String formatDuration(String minutesStr) {
    final totalMinutes = int.tryParse(minutesStr) ?? 0;
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;

    if (hours > 0 && mins > 0) {
      return "${hours}h ${mins}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else {
      return "${mins}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Get.theme.colorScheme.onPrimary,
      color: Get.theme.colorScheme.primary,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                    Gap(5.w),
                    Text(
                      date.split(" ").first,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Get.theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(8.h),

            /// Description
            Html(
              data: description,
              style: {
                "body": Style(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: FontSize(14.sp),
                  margin: Margins.zero,
                  padding: HtmlPaddings.all(0),
                ),
              },
            ),
            Gap(12.h),

            if (file.isNotEmpty)
             Bounceable(
                onTap: () => navigateToAttachmentViewer(file),
               child: Container(
                height: 40.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onPrimary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "View Attachment",
                  style: TextStyle(
                    color: Get.theme.colorScheme.primary,
                    fontSize: 14.sp,
               
                  ),
                ),
               ),
             )
             

          ],
        ),
      ),
    );
  }
}



// Placeholder Widgets (Replace these with your actual PDF/Image viewer logic)

class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppbar(),
      body: SfPdfViewer.network(
        filePath,
        // You can add a loading indicator while the PDF is downloading
        onDocumentLoadFailed: (details) {
          debugPrint('PDF Loading Failed: ${details.description}');
          // Optionally show an error message to the user
          Get.snackbar(
            "Error",
            "Could not load PDF document. Please check the URL.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade400,
            colorText: Colors.white,
          );
        },
      ),
    );
  }
}


class ImageViewerScreen extends StatelessWidget {
  final String filePath;
  const ImageViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    // We use Image.network assuming 'filePath' is a URL.
    // If it's a local file path, you would use Image.file(File(filePath))
    return Scaffold(
      appBar: CustomAppbar(),
      body: Center(
        child: InteractiveViewer( // Allows zooming and panning the image
          child: Image.network(
            filePath,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Image Loading Error: $error');
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text('Failed to load image.'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
// ----------------------------------------------------------------------

void navigateToAttachmentViewer(String file) {
  // 1. Extract the file extension and normalize it
  final extension = p.extension(file).toLowerCase();

  // 2. Define a list of common image extensions
  const imageExtensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.tiff', '.tif'};

  if (extension == '.pdf') {
    // Case 1: PDF File
    Get.to(() => PdfViewerScreen(filePath: file));
  } else if (imageExtensions.contains(extension)) {
    // Case 2: Image File
    Get.to(() => ImageViewerScreen(filePath: file));
  } else {
    // Case 3: Fallback for all other files (text, zip, unknown, etc.)
    Get.to(() => Scaffold(
          appBar: AppBar(
            title: const Text("Attachment"),
          ),
          body: Center(
            child: Text(
              "Here you can implement file viewing logic for:\n$file\n(Extension: $extension)",
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

// Example usage:
// navigateToAttachmentViewer('https://example.com/report.pdf');
// navigateToAttachmentViewer('https://example.com/photo.jpeg');
// navigateToAttachmentViewer('https://example.com/data.txt');
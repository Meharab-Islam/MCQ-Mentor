import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/pdf/all_pdf_list_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfOpenDownloadController extends GetxController{
  Dio dio = Dio();

  /// 🔹 Open PDF inside the app
  Future<void> openPdfInApp(String pdfUrl, String fileName) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final file = await _downloadAndSaveFile(pdfUrl, "$fileName.pdf");
      Get.back();

      Get.to(() => PdfViewerPage(filePath: file.path, title: fileName));
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to open PDF: $e');
    }
  }

  /// 🔹 Download PDF with Dio

/// 🔹 Download PDF with Dio (first request permission, then download)
Future<void> downloadPdf(String pdfUrl, String fileName) async {
  try {
    // Request permission
 if (Platform.isAndroid) {
  if (await Permission.manageExternalStorage.isDenied) {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to save PDFs',
        snackPosition: SnackPosition.BOTTOM,
      );
      Permission.manageExternalStorage.request();
      return;
    }
  }
}


    // Determine save location
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/BCS_PDFs');
      if (!await dir.exists()) await dir.create(recursive: true);
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      throw Exception('Unsupported platform');
    }

    final savePath = '${dir.path}/$fileName.pdf';

    // Show progress dialog
    Get.dialog(
      AlertDialog(
        title: const Text('Downloading PDF'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Downloading $fileName.pdf ...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Download using Dio
    final dio = Dio();
    await dio.download(
      pdfUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(0);
          debugPrint('Download progress: $progress%');
        }
      },
    );

    Get.back(); // Close dialog
    Get.snackbar('✅ Download Complete', 'Saved to: $savePath',
        snackPosition: SnackPosition.BOTTOM);
  } catch (e) {
    Get.back();
    Get.snackbar('Error', 'Failed to download PDF: $e',
        snackPosition: SnackPosition.BOTTOM);
  }
}


  /// 🔹 Open in external browser
  Future<void> openPdfExternal(String pdfUrl) async {
    final uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Cannot open link');
    }
  }

  /// 🔹 Download file for viewing in app
  Future<File> _downloadAndSaveFile(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    await dio.download(url, filePath);
    return File(filePath);
  }
}
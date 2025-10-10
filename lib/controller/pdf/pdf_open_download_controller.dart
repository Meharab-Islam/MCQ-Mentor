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
    print('🔽 Starting PDF download...');
    print('PDF URL: $pdfUrl');
    print('File name: $fileName');

    // Request permission
    if (Platform.isAndroid) {
      print('📱 Platform: Android - Checking manageExternalStorage permission...');
      if (await Permission.manageExternalStorage.isDenied) {
        print('⚠️ Permission is denied, requesting permission...');
        final status = await Permission.manageExternalStorage.request();
        print('📄 Permission status: ${status.isGranted ? "GRANTED" : "DENIED"}');
        if (!status.isGranted) {
          print('❌ Storage permission denied');
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to save PDFs',
            snackPosition: SnackPosition.BOTTOM,
          );
          Permission.manageExternalStorage.request();
          return;
        }
      } else {
        print('✅ Permission already granted.');
      }
    }

    // Determine save location
    print('📂 Determining save location...');
    Directory dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download/BCS_PDFs');
      print('📁 Android save directory: ${dir.path}');
      if (!await dir.exists()) {
        print('📦 Directory does not exist — creating...');
        await dir.create(recursive: true);
        print('✅ Directory created successfully.');
      } else {
        print('📁 Directory already exists.');
      }
    } else if (Platform.isIOS) {
      print('🍏 Platform: iOS - Getting application documents directory...');
      dir = await getApplicationDocumentsDirectory();
      print('📁 iOS save directory: ${dir.path}');
    } else {
      throw Exception('Unsupported platform');
    }

    final savePath = '${dir.path}/$fileName.pdf';
    print('📄 File will be saved to: $savePath');

    // Show progress dialog
    print('📤 Showing download dialog...');
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
    print('⬇️ Starting Dio download...');
    final dio = Dio();
    await dio.download(
      pdfUrl,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          final progress = (received / total * 100).toStringAsFixed(0);
          print('📊 Download progress: $progress% ($received/$total bytes)');
        }
      },
    );

    print('✅ Download completed successfully!');
    Get.back(); // Close dialog
    Get.snackbar(
      '✅ Download Complete',
      'Saved to: $savePath',
      snackPosition: SnackPosition.BOTTOM,
    );
    print('📦 Snackbar shown: Download Complete.');
  } catch (e) {
    print('❌ Error occurred: $e');
    Get.back();
    Get.snackbar(
      'Error',
      'Failed to download PDF: $e',
      snackPosition: SnackPosition.BOTTOM,
    );
    print('🚨 Snackbar shown: Download failed.');
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
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

void showExplanationDialog(BuildContext context, String explanation) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Explanation"),
      content: SingleChildScrollView(
        child: Html(
          data:
              explanation.isNotEmpty ? explanation : "No explanation available.",
          style: {
            "p": Style(fontSize: FontSize(16)),
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

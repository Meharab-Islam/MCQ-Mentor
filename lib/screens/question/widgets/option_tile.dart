import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionTile extends StatelessWidget {
  final String option;
  final bool isCorrect;
  final String label;

  const OptionTile({super.key, required this.option, required this.isCorrect, required this.label});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: ListTile(
        leading: Container(
          height: 30.w,
          width: 30.w,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(label, style: TextStyle(
              fontSize: 16.sp
            ),),
          ),
        ),
        title: Html(
          data: option,
          style: {
            "html": Style(
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
            "body": Style(
              fontSize: FontSize(16.sp),
              color: isCorrect ? Colors.white : Colors.black87,
              fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
            ),
          },
        ),
        onTap: null,
      ),
    );
  }
}

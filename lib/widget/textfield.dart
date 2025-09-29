import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A reusable widget for a custom text field with filled background.
/// This widget now supports password visibility toggling and responsive sizing
/// using GetX for reactive state management.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Use an RxBool for reactive state management.
    final RxBool obscureText = isPassword ? true.obs : false.obs;

    return Obx(
      () => TextField(
        keyboardType: keyboardType,
        controller: controller,
        // Use the reactive variable to control text obscuring.
        obscureText: obscureText.value,
        // The style of the text being entered.
        style: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 14.sp, // Use responsive font size
        ),
        cursorColor: colorScheme.onBackground,
        decoration: InputDecoration(
          filled: true,
          hintStyle: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14.sp, // Use responsive font size
          ),
          fillColor: colorScheme.surface,
          hintText: hintText,
          // The default border style for the text field.
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r), // Use responsive radius
            borderSide: BorderSide(
              color: colorScheme.secondary,
              width: 1.w, // Use responsive width
            ),
          ),
          // The border style when the text field is focused.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r), // Use responsive radius
            borderSide: BorderSide(
              color: colorScheme.secondary,
              width: 2.w, // Use responsive width
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.w, // Use responsive padding
            vertical: 13.h, // Use responsive padding
          ),
          // Add a show/hide icon for password fields.
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText.value ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurface,
                  ),
                  onPressed: () {
                    // Toggle the value of the reactive variable.
                    obscureText.toggle();
                  },
                )
              : null,
        ),
      ),
    );
  }
}

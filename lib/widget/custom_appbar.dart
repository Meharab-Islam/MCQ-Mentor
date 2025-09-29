// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return AppBar(
      centerTitle: false,
      title: Text(
        "MCQ Mentor",
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal),
      ),
      actions: [
        // Toggle Theme Button
        // Obx(() => IconButton(
        //       icon: Icon(
        //         themeController.isDarkMode.value
        //             ? Icons.wb_sunny
        //             : Icons.dark_mode,
        //       ),
        //       onPressed: () => themeController.toggleTheme(),
        //     )),

        // Notifications Button
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

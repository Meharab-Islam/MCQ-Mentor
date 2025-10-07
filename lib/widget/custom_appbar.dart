// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';
import 'package:mcq_mentor/screens/notification/notification_screen.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({super.key, this.title = "MCQ Mentor"});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Image.asset(AppImages.hat,width: 40,height: 30,),
          Gap(5.w),
          Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
           Get.to(()=> NotificationScreen());
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

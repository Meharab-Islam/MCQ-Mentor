// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';
import 'package:mcq_mentor/controller/notification/notification_list_controller.dart';
import 'package:mcq_mentor/screens/notification/notification_screen.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotificationIcon;
  final bool showBackButton;
  final VoidCallback? backButtonAction;
  const CustomAppbar({super.key, this.title = "MCQ Mentor", this.showNotificationIcon = true, this.backButtonAction, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final notificationController = Get.put(NotificationController(), permanent: true);

    return AppBar(
      centerTitle: false,
      leading: showBackButton? IconButton(
        icon: Icon(Icons.arrow_back, size: 24.sp,),
        onPressed: backButtonAction ?? () {
          Get.back();
        },
      ):null,
      title: Row(
        children: [
          Image.asset(AppImages.hat, width: 40, height: 30),
          Gap(5.w),
          Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      actions: [
        // 🔔 Notification Icon with Unread Badge
       showNotificationIcon? Obx(() {
          int unreadCount = notificationController.notifications
              .where((n) => !n.isRead)
              .length;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon:  Icon(Icons.notifications_none, size: 30.sp,),
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
              ),

              // 🟥 Red badge for unread count
              if (unreadCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }):SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

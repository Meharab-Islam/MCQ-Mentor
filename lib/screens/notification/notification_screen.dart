import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/notification/notification_list_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppbar(
        title: "Notifications",
        showNotificationIcon: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications available 😔"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final item = controller.notifications[index];

            // 🔥 Observe expandedIndex and notification list changes
            return Obx(() {
              final isExpanded = controller.expandedIndex.value == index;
              final isUnread = !item.isRead;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isUnread ? Colors.blue.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: isUnread
                      ? Border.all(color: Colors.blue.shade300, width: 1.2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧾 Title + unread badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.bold,
                                color: Get.theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                "Unread",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      Gap(8.h),

                      // ✨ Description
                      if (!isExpanded)
                        Text(
                          _stripHtmlTags(item.description),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        Html(
                          data: item.description,
                          style: {
                            "body": Style(
                              fontSize: FontSize(15.sp),
                              color: Colors.black87,
                              lineHeight: LineHeight(1.5),
                            ),
                            "strong": Style(
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            "a": Style(
                              textDecoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          },
                        ),

                      Gap(8.h),

                      // 🔘 See More / See Less
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            controller.toggleExpand(index);

                            // ✅ If unread, mark as read when expanded
                            if (isUnread) {
                              controller.markAsRead(index);
                            }
                          },
                          icon: AnimatedRotation(
                            duration: const Duration(milliseconds: 250),
                            turns: isExpanded ? 0.5 : 0.0,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                          ),
                          label: Text(
                            isExpanded ? "See Less" : "See More",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
    );
  }

  /// Helper: Strip HTML tags for preview text
  String _stripHtmlTags(String htmlText) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
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
      appBar: CustomAppbar(title: "Notifications"),
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

            // 🔥 Wrap each tile in Obx to respond to expand/collapse
            return Obx(() {
              final isExpanded = controller.expandedIndex.value == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🧾 Title
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // ✨ AnimatedCrossFade for smooth expand/collapse
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 350),
                        firstCurve: Curves.easeInOut,
                        secondCurve: Curves.easeInOut,
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Text(
                          _stripHtmlTags(item.description),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: AnimatedOpacity(
                          opacity: isExpanded ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Html(
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
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // 🔘 See More / See Less button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => controller.toggleExpand(index),
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

  /// Helper: Strip HTML tags for collapsed preview
  String _stripHtmlTags(String htmlText) {
    final exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcq_mentor/controller/routine/all_routine_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class AllRoutineScreen extends StatelessWidget {
  final String examSectionId;
  final String examCategoryId;
  const AllRoutineScreen({super.key, required this.examSectionId, required this.examCategoryId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllRoutineController(
      examSectionId: examSectionId,
      examCategoryId: examCategoryId,
    ));

    return Scaffold(
      appBar: CustomAppbar(),
      body: Column(
        children: [
          /// 🔍 Search bar
          Padding(
            padding: EdgeInsets.all(12.w),
            child: TextField(
              onChanged: (value) => controller.setSearch(value),
              cursorColor:  Get.theme.colorScheme.onPrimary,
              
              decoration: InputDecoration(
                
                hintText: "Search routine...",
                hintStyle: TextStyle(
                    color: Get.theme.colorScheme.onPrimary,
                ),
                prefixIcon:  Icon(Icons.search, color: Get.theme.colorScheme.onPrimary,),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Get.theme.colorScheme.onPrimary,),
                
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Get.theme.colorScheme.onPrimary,),
                ),
                filled: true,
                fillColor: Get.theme.colorScheme.primary,
                
              ),
            ),
          ),

          /// ✅ List of routines
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.routines.isEmpty) {
                return  Center(child: CircularProgressIndicator(
                  color: Get.theme.colorScheme.onPrimary,
                ));
              }

              if (controller.routines.isEmpty) {
                return const Center(child: Text("No routines found"));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification.metrics.pixels >=
                          scrollNotification.metrics.maxScrollExtent - 200 &&
                      !controller.isLoading.value &&
                      controller.pagination.value?.nextPage != null) {
                    controller.fetchRoutines();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  itemCount: controller.routines.length +
                      (controller.pagination.value?.nextPage != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.routines.length) {
                      final routine = controller.routines[index];
                      return RoutineCard(
                        title: routine.name,
                        description: routine.description,
                        date: routine.date,
                        duration: routine.duration,
                        marks: routine.totalMarks,
                      );
                    } else {
                      /// Show loader at bottom while fetching next page
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child:  Center(
                          child: CircularProgressIndicator(
                              color: Get.theme.colorScheme.onPrimary,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// ✅ Routine card widget
class RoutineCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String duration; // in minutes from API
  final String marks;

  const RoutineCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.duration,
    required this.marks,
  });

  /// Convert minutes -> "Xh Ym"
  String formatDuration(String minutesStr) {
    final totalMinutes = int.tryParse(minutesStr) ?? 0;
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;

    if (hours > 0 && mins > 0) {
      return "${hours}h ${mins}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else {
      return "${mins}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Get.theme.colorScheme.onPrimary,
      color: Get.theme.colorScheme.primary,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Get.theme.colorScheme.onPrimary),
                    Gap(5.w),
                    Text(
                      date.split(" ").first,
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: Get.theme.colorScheme.onPrimary),
                    ),
                  ],
                ),
              ],
            ),
            Gap(8.h),

            /// Description
            Text(
              description,
              style: TextStyle(
                  fontSize: 13.sp, color: Get.theme.colorScheme.onPrimary),
            ),
            Gap(12.h),

            /// Footer info (center aligned)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 16.sp, color: Colors.orange),
                Gap(6.w),
                Text(
                  formatDuration(duration),
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Get.theme.colorScheme.onPrimary),
                ),
                Gap(140.w),
                Icon(Icons.score, size: 16.sp, color: Colors.blue),
                Gap(6.w),
                Text(
                  "$marks marks",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: Get.theme.colorScheme.onPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

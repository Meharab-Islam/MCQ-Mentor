import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/category_section/all_category_list_controller.dart';
import 'package:mcq_mentor/controller/category_section/single_category_details_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class CategorySectionListScreen extends StatelessWidget {
  final int examSectionId;
  const CategorySectionListScreen({super.key, required this.examSectionId});


  @override
  Widget build(BuildContext context) {
    final AllCategoryListController allCategoryListController = Get.put(
      AllCategoryListController(
        examSectionId: examSectionId,
      ),
    );
    final SingleCategoryDetailsController singleCategoryDetailsController = Get.put(SingleCategoryDetailsController());

    return Scaffold(
      appBar: CustomAppbar(),
      body: Obx(() {
        // ignore: invalid_use_of_protected_member
        final categoryList = allCategoryListController.categoryList.value;

        if (allCategoryListController.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (categoryList.isEmpty) {
          return const Center(child: Text("No Data found"));
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                // Text(
                //   categoryList.name,
                //   style: TextStyle(
                //     fontSize: 20.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // Gap(5.h),

                /// Description box
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.all(10.sp),
                //   decoration: BoxDecoration(
                //     color: Colors.amber,
                //     borderRadius: BorderRadius.circular(10.r),
                //   ),
                //   child: Center(
                //     child: Text(
                //       examData.data.description == null ? "No description available": examData.data.description.toString(),
                //       textAlign: TextAlign.center,
                //       style: const TextStyle(color: Colors.black),
                //     ),
                //   ),
                // ),
                // Gap(10.h),

                /// Category List
                Expanded(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      final item = categoryList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: itemCard(
                          context,
                          title: item.name,
                          onTap: () {
                            singleCategoryDetailsController.fetchExamSections(item.id.toString());
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget itemCard(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundColor: Theme.of(context).colorScheme.onPrimary,
            //   child: Image.network(
            //     iconUrl,
            //     width: 24.w,
            //     height: 24.h,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            // Gap(12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

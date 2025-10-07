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
          return  Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        } else if (categoryList.isEmpty) {
          return const Center(child: Text("No Data found"));
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

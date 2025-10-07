// package_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcq_mentor/controller/packages/package_list_controller.dart';
import 'package:mcq_mentor/screens/packages/package_details_screen.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class PackageListScreen extends StatelessWidget {
 final bool isMain;
  const PackageListScreen({super.key, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    final PackageListController controller = Get.put(PackageListController());
    final ScrollController scrollController = ScrollController();

    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoading.value &&
          controller.page.value < controller.totalPages.value) {
        controller.loadNextPage();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: isMain==false? CustomAppbar(title: "Packages",):null,
      body: Obx(() {
        if (controller.isLoading.value && controller.packages.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary),
          );
        }

        if (controller.packages.isEmpty) {
          return const Center(child: Text("No packages found 😔"));
        }

        return Container(
          margin: EdgeInsets.only(bottom: isMain?100:0),
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(12.w),
            itemCount: controller.packages.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.packages.length) {
                // Pagination loader
                return controller.page.value < controller.totalPages.value
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary),
                        ),
                      )
                    : const SizedBox.shrink();
              }
          
              final package = controller.packages[index];
          
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                elevation: 6,
                shadowColor: Colors.grey.withOpacity(0.4),
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Package name & price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                package.name,
                                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                               color: Get.theme.colorScheme.onPrimary.withAlpha(50)
                              ),
                              child: Text(
                                "৳${package.price}",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
          
                        SizedBox(height: 6.h),
                        Text(
                          package.description,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                            SizedBox(width: 4.w),
                            Text(
                              "Duration: ${package.duration}",
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                            ),
                          ],
                        ),
          
                        SizedBox(height: 10.h),
          
                        // "See Details" button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            ),
                            onPressed: () {
                              Get.to(() => PackageDetailScreen(packageId: package.id));
                            },
                            child: Text("See Details", style: TextStyle(fontSize: 14.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

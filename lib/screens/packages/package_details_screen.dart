import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcq_mentor/controller/packages/package_detail_controller.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

class PackageDetailScreen extends StatelessWidget {
  final int packageId;

  const PackageDetailScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PackageDetailController());
    controller.fetchPackageDetail(packageId);

    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      appBar: CustomAppbar(
        title: "Details",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        }

        final package = controller.packageDetail.value;
        if (package == null) {
          return const Center(child: Text("No package data available 😔"));
        }

        return Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    package.name,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Description
                  Text(
                    package.description,
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                  ),
                  // SizedBox(height: 16.h),

                  // Price and Duration Card
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "৳${package.price}",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          "⏱ ${package.duration}",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Features Section
                  Text(
                    "Package Features",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  ...package.packageFeatures.map(
                    (feature) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle,
                            color: Colors.green),
                        title: Text(
                          feature.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Purchase Button (Fixed at bottom)
            Positioned(
              bottom: 16.h,
              left: 16.w,
              right: 16.w,
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Get.theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    // TODO: Add payment or purchase logic here
                    Get.snackbar(
                      "Purchase",
                      "Proceeding to purchase ${package.name}",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor:
                          Get.theme.colorScheme.onPrimary.withOpacity(0.1),
                    );
                  },
                  child: Text(
                    "Purchase Now for ৳${package.price}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

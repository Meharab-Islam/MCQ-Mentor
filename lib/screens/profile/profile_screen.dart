import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mcq_mentor/screens/profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        // Loader
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.onPrimary,
            ),
          );
        }

        // Empty profile
        if (controller.studentProfile.value == null) {
          return const Center(child: Text("No profile data found"));
        }

        final student = controller.studentProfile.value!;

        return RefreshIndicator(
          color: Get.theme.colorScheme.onPrimary,
           onRefresh: () async {
    await controller.fetchStudentProfile();
  },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight, // ensures full screen scroll
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ===== USER INFO =====
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: CachedNetworkImage(
                              imageUrl:
                                  (student.image != null &&
                                      student.image!.isNotEmpty)
                                  ? student.image!
                                  : 'https://mcqmentor.com/logo.png',
                              height: 150.h,
                              width: 120.w,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 150.h,
                                width: 120.w,
                                alignment: Alignment.center,
                                color: Colors.grey.shade200,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 150.h,
                                width: 120.w,
                                alignment: Alignment.center,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.broken_image_outlined,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  student.email,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Phone: ${student.phone ?? 'N/A'}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Gender: ${student.gender ?? 'N/A'}, Age: ${student.age ?? 'N/A'}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                Gap(10.h),
                                SizedBox(
                                  width: 180,
                                  height: 45,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Get.to(
                                        () =>
                                            EditProfileScreen(userData: student),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_note_outlined,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Get.theme.colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    label: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                        color: Get.theme.colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
          
                      /// ===== ADDRESS & DOB =====
                      Text(
                        "Address: ${student.address ?? 'N/A'}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Date of Birth: ${_formatDate(student.dateOfBirth?.toString())}",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(height: 24.h),
          
                      /// ===== PACKAGES =====
                      /// ===== PACKAGES =====
                      Text(
                        "Active Packages",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (student.packages.isEmpty)
                        Text(
                          "No active packages found",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        )
                      else
                        Column(
                          children: student.packages.map<Widget>((package) {
                            final pkg = package.package;
          
                            // Calculate expiry date
                            DateTime? purchaseDate =
                                package.paymentDate.toString().isNotEmpty
                                ? DateTime.tryParse(
                                    package.paymentDate.toString(),
                                  )
                                : null;
                            DateTime? expiryDate;
                            if (purchaseDate != null && pkg.duration != null) {
                              expiryDate = purchaseDate.add(
                                Duration(days: int.parse(pkg.duration)),
                              );
                            }
          
                            return Card(
                              margin: EdgeInsets.only(bottom: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Package Name
                                    Row(
                                      children: [
                                        Text(
                                          pkg.name,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                pkg.status.toLowerCase() ==
                                                    'active'
                                                ? Colors.green
                                                : Colors.red.shade300,
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Text(
                                            pkg.status.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(8.h),
          
                                    // Price & Duration
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Price: ${pkg.price} BDT",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Duration: ${pkg.duration} days",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
          
                                    // Expiry Date
                                    Text(
                                      "Expiry Date: ${expiryDate != null ? DateFormat('d MMM yyyy').format(expiryDate) : 'N/A'}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
          
                                    // Status
                                    SizedBox(height: 12.h),
          
                                    // Features List
                                    Text(
                                      "Features:",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: pkg.features.map((feature) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2.h,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 16.sp,
                                                color: Colors.blue.shade700,
                                              ),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: Text(
                                                  feature.name,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
          
          Gap(70.h),
                      // SizedBox(height: 24.h),
          
                      // /// ===== EXAM HISTORY =====
                      // Text("Exam History",
                      //     style:
                      //         TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      // SizedBox(height: 12.h),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

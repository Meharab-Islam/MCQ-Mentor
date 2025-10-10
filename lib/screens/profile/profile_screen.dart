import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mcq_mentor/screens/profile/edit_profile_screen.dart';
import 'package:mcq_mentor/widget/under_maintance_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        // Show loader while loading
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,));
        }

        // Show error or empty state if profile not loaded
        if (controller.studentProfile.value == null) {
          return const Center(child: Text("No profile data found"));
        }

        final student = controller.studentProfile.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ======== USER INFO SECTION ========
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: student.image.isNotEmpty
                          ? student.image
                          : 'https://i.pinimg.com/564x/39/33/f6/3933f64de1724bb67264818810e3f2cb.jpg',
                      height: 150.h,
                      width: 120.w,
                      fit: BoxFit.cover,

                      // While loading
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

                      // On error
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
                        Text(student.email, style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 4.h),
                        Text(
                          "Phone: ${student.phone}",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Gender: ${student.gender}, Age: ${student.age}",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Gap(10.h),
                        SizedBox(
                          width: 180,
                          height: 45,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Get.to(()=> EditProfileScreen(userData: student,));
                              Get.to(()=> UnderMaintanceScreen());
                            },
                            icon: Icon(Icons.edit_note_outlined, color: Colors.white,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.colorScheme.onPrimary,
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

              /// ======== ADDRESS & DOB ========
              Text(
                "Address: ${student.address}",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                "Date of Birth: ${_formatDate(student.dateOfBirth.toString())}",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),

              /// ======== PACKAGES SECTION ========
              // Text("Packages",
              //     style:
              //         TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              // SizedBox(height: 12.h),
              // Column(
              //   children: controller.packages.map<Widget>((package) {
              //     return Card(
              //       elevation: 2,
              //       margin: EdgeInsets.symmetric(vertical: 6.h),
              //       child: ListTile(
              //         title: Text(
              //           package['name'] ?? '',
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         subtitle: Text("Expiry: ${package['expiry'] ?? 'N/A'}"),
              //         leading: const Icon(Icons.card_membership,
              //             color: Colors.blueAccent),
              //       ),
              //     );
              //   }).toList(),
              // ),
              // SizedBox(height: 24.h),

              // /// ======== EXAMS SECTION ========
              // Text("Exams",
              //     style:
              //         TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              // SizedBox(height: 12.h),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: controller.exams.length,
              //   itemBuilder: (context, index) {
              //     final exam = controller.exams[index];
              //     Color statusColor;
              //     if (exam['status'] == "Completed") {
              //       statusColor = Colors.green;
              //     } else if (exam['status'] == "Pending") {
              //       statusColor = Colors.orange;
              //     } else {
              //       statusColor = Colors.red;
              //     }

              //     return Card(
              //       elevation: 2,
              //       margin: EdgeInsets.symmetric(vertical: 6.h),
              //       child: ListTile(
              //         title: Text(
              //           exam['title'] ?? '',
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         subtitle: Text("Score: ${exam['score'] ?? 'N/A'}"),
              //         trailing: Text(
              //           exam['status'] ?? '',
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, color: statusColor),
              //         ),
              //         leading: const Icon(Icons.school,
              //             color: Colors.blueAccent),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy').format(date); // Example: 12 May 2003
    } catch (e) {
      return dateStr; // fallback if parse fails
    }
  }
}

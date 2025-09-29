import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        foregroundColor: Get.theme.colorScheme.primary,
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary,))
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Section
              Row(
                children: [
                  Container(
                    height: 150.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      image: DecorationImage(image: controller.user['image'] != null
                        ? NetworkImage(controller.user['image']!)
                        : const AssetImage('assets/default_user.png') as ImageProvider,fit: BoxFit.cover)
                    ),
                  
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.user['name']!,
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(controller.user['email']!, style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 4.h),
                        Text("Phone: ${controller.user['phone']}", style: TextStyle(fontSize: 14.sp)),
                        SizedBox(height: 4.h),
                        Text("Gender: ${controller.user['gender']}, Age: ${controller.user['age']}", style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Address & DOB
              Text(
                "Address: ${controller.user['address']}",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                "Date of Birth: ${controller.user['date_of_birth']}",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),

              // Packages Section
              Text("Packages", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
           Column(
  children: controller.packages.map<Widget>((package) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        title: Text(
          package['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Expiry: ${package['expiry']}"),
        leading: const Icon(Icons.card_membership, color: Colors.blueAccent),
      ),
    );
  }).toList(),
),

              SizedBox(height: 24.h),

              // Exams Section
              Text("Exams", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.exams.length,
                itemBuilder: (context, index) {
                  final exam = controller.exams[index];
                  Color statusColor;
                  if (exam['status'] == "Completed") {
                    statusColor = Colors.green;
                  } else if (exam['status'] == "Pending") {
                    statusColor = Colors.orange;
                  } else {
                    statusColor = Colors.red;
                  }

                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 6.h),
                    child: ListTile(
                      title: Text(exam['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Score: ${exam['score']}"),
                      trailing: Text(
                        exam['status'],
                        style: TextStyle(fontWeight: FontWeight.bold, color: statusColor),
                      ),
                      leading: const Icon(Icons.school, color: Colors.blueAccent),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

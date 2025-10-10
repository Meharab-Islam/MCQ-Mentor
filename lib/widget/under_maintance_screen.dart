import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/widget/typewriter_text.dart';

class UnderMaintanceScreen extends StatelessWidget {
  const UnderMaintanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 350.h,
            width: double.infinity,
            child: Image.asset(AppImages.maintance3, fit: BoxFit.cover),
          ),
          Center(
            child: TypewriterText(
              text: "Under Maintenance",
              style: TextStyle(
                fontSize: 35.sp,
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onPrimary,
              ),
              speed: const Duration(milliseconds: 120),
              loop: true,
            ),
          ),
// Text("Under Maintenance"),
          Gap(10.h),
          Padding(
            padding: EdgeInsets.all(15.sp),
            child: Bounceable(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.white),
                      Text(
                        "Get Back",
                        style: TextStyle(color: Colors.white, fontSize: 19.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

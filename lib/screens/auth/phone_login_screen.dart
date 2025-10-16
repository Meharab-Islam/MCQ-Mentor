import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mcq_mentor/controller/auth/registration_controller.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:mcq_mentor/widget/primary_button.dart';
import 'package:mcq_mentor/controller/auth/login_controller.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RegistrationController registrationController = Get.put(RegistrationController());

    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? colorScheme.primary
        : colorScheme.background;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ColorfulSafeArea(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(100.h),

                // 🔹 Animated logo
                const LogoWidget()
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),

                Gap(20.h),

                Text(
                  "Login with your phone number",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onBackground.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),

                Gap(30.h),

                // 🔹 Phone input with country picker
                IntlPhoneField(
                  
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    
                    fillColor: colorScheme.onBackground.withOpacity(
                      isDarkMode ? 0.1 : 0.05,
                    ),
                  ),
                  controller: registrationController.phoneController,
                  initialCountryCode: 'BD',
                  cursorColor: Colors.black,
                  onChanged: (phone) {
                    // controller.phoneNumber.value = phone.completeNumber;
                  },
                ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.3),

                Gap(20.h),

                Obx(() {
                  if (registrationController.isLoading.value) {
                    return CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                    ).animate().fadeIn();
                  } else {
                    return PrimaryButton(
                      title: "Send OTP",
                      onTap: () {
                        registrationController.register();
                      },
                    ).animate().scale(
                      duration: 400.ms,
                      begin: Offset(0.9, 0.9),
                    );
                  }
                }),

                Gap(30.h),
   
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey.withOpacity(0.5),
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              "or",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground.withOpacity(0.7),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey.withOpacity(0.5),
                              thickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(10.h),
                    Bounceable(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        // height: 30.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 15.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.r)
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(Icons.email_outlined, color: Get.theme.colorScheme.onPrimary,),
                              Gap(15.w),
                              Text("Login With Email", style: TextStyle(
                                color: Colors.grey.shade900, fontSize: 15.sp,
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

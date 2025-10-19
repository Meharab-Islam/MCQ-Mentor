
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/auth/verify_mobile_login_otp.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:pinput/pinput.dart';

class VerifyMobileLoginOtpScreen extends StatelessWidget {

  final String phoneNumber; // ✅ Pass email from previous screen

  const VerifyMobileLoginOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? colorScheme.primary : colorScheme.background;

    // Instantiate & initialize controller
    final VerifyMobileLoginOtp controller = Get.put(VerifyMobileLoginOtp());
    controller.phoneController.text = phoneNumber;


    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colorScheme.onSurface,
          width: 1.w,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onBackground),
          onPressed: () => Get.back(),
        ),
      ),
      body: ColorfulSafeArea(
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(100.h),
                  const LogoWidget(),
                  Gap(20.h),
                  Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10.h),
                  Text(
                    'We have sent a 4-digit verification code to $phoneNumber.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onBackground.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(20.h),
                  Pinput(
                    controller: controller.otpController,
                    length: 4,
                    keyboardType: TextInputType.number,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(
                          color: colorScheme.secondary,
                          width: 2.w,
                        ),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: colorScheme.secondary.withOpacity(0.1),
                        border: Border.all(
                          color: colorScheme.secondary,
                          width: 2.w,
                        ),
                      ),
                    ),
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                      controller.login();
                    },
                  ),
                  Gap(10.h),
                 
                  Gap(20.h),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

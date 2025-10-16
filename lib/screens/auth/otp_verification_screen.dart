import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/otp_controller.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String type;
  final String email; // ✅ Pass email from previous screen

  const OtpVerificationScreen({
    super.key,
    required this.type,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? colorScheme.primary : colorScheme.background;

    // Instantiate & initialize controller
    final OtpController controller = Get.put(OtpController());
    controller.init(email, type);

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
                    'We have sent a 4-digit verification code to $email.',
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
                    focusNode: controller.otpFocusNode,
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
                      controller.verifyOtp();
                    },
                  ),
                  Gap(10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => TextButton(
                        onPressed: controller.canResend.value
                            ? controller.resendOtp
                            : null,
                        child: Text(
                          controller.canResend.value
                              ? 'Resend OTP'
                              : 'Resend in ${controller.timer.value}s',
                          style: TextStyle(
                            color: controller.canResend.value
                                ? colorScheme.onBackground
                                : colorScheme.onBackground.withOpacity(0.5),
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
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

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/auth/forget_password_controller.dart';
import 'package:mcq_mentor/screens/auth/otp_verification_screen.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:mcq_mentor/widget/primary_button.dart';
import 'package:mcq_mentor/widget/textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController controller = Get.put(
    ForgotPasswordController(),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode
        ? colorScheme.primary
        : colorScheme.background;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ dismiss keyboard
      child: Scaffold(
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
                    Gap(120.h),
                    const LogoWidget(),
                    Gap(20.h),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(10.h),
                    Text(
                      'Enter your email address to receive a password reset link.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(20.h),
                    CustomTextField(
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                    ),
                    Gap(30.h),

                    /// ✅ Loader replaces the button
                    Obx(() {
                      if (controller.isLoading.value) {
                        return  CircularProgressIndicator(
                          color: Get.theme.colorScheme.onPrimary,
                        );
                      }
                      return PrimaryButton(
                        onTap: () async {
                          final success = await controller.sendResetLink();
                          if (success) {
                            Get.to(
                              () => OtpVerificationScreen(
                                type: "reset_password",
                                email: controller.emailController.text,
                              ),
                            );
                          }
                        },
                        title: 'Reset Password',
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

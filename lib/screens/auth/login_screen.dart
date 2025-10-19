import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/auth/google_auth_controller.dart';
import 'package:mcq_mentor/controller/auth/login_controller.dart';
import 'package:mcq_mentor/screens/auth/forget_password_screen.dart';
import 'package:mcq_mentor/screens/auth/phone_login_screen.dart';
import 'package:mcq_mentor/screens/auth/registration_screen.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:mcq_mentor/widget/primary_button.dart';
import 'package:mcq_mentor/widget/textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.find<LoginController>();
    GoogleAuthController googleAuthController = Get.put(GoogleAuthController());

    // Access the current theme's color scheme
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? colorScheme.primary
        : colorScheme.background;

    final loaderColor = isDarkMode
        ? colorScheme.onPrimary
        : colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ dismiss keyboard
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: ColorfulSafeArea(
          color: backgroundColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gap(70.h),
                    const LogoWidget(),
                    Gap(20.h),
                    Text(
                      'Your Ultimate MCQ Preparation Companion',
                      style: TextStyle(
                        fontSize: 18.sp,
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
                    Gap(10.h),
                    CustomTextField(
                      hintText: 'Enter your password',

                      controller: controller.passwordController,
                      isPassword: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => ForgotPasswordScreen());
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 14.sp,
                            decoration: TextDecoration.underline,
                            decorationColor: colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return CircularProgressIndicator(color: loaderColor);
                      } else {
                        return PrimaryButton(
                          onTap: () {
                            controller.login();
                          },
                          title: 'Login',
                        );
                      }
                    }),
                    Gap(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 13.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const RegistrationScreen());
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(15.h),
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
                        Get.to(()=> PhoneLoginScreen());
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
                              Icon(Icons.mobile_screen_share_sharp, color: Get.theme.colorScheme.onPrimary,),
                              Gap(15.w),
                              Text("Login With Mobile Number", style: TextStyle(
                                color: Colors.grey.shade900, fontSize: 15.sp,
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(10.h),
                   Obx(() {
  final loading = googleAuthController.isLoading.value;

  return Bounceable(
    onTap: loading
        ? null
        : () {
            googleAuthController.signInWithGoogle();
          },
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 15.h,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: loading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.grey.shade700),
                ),
              )
            : Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.network(
                    'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
                    width: 25.w,
                    height: 25.h,
                  ),
                  Gap(15.w),
                  Text(
                    "Login With Google",
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
      ),
    ),
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

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/widget/logo.dart';
import 'package:mcq_mentor/widget/primary_button.dart';
import 'package:mcq_mentor/widget/textfield.dart';

import '../../controller/auth/registration_controller.dart';
import '../../controller/image_picker_controller.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme colors
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? colorScheme.primary : colorScheme.background;

    // Controllers
    final ImagePickerController imageController = Get.put(ImagePickerController());
    final RegistrationController regController = Get.put(RegistrationController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ColorfulSafeArea(
        top: true,
        color: backgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(40.h),
                  const LogoWidget(),
                  Gap(20.h),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(10.h),
                  CustomTextField(
                    hintText: 'Enter your full name',
                    controller: regController.nameController,
                  ),
                  Gap(10.h),
                  CustomTextField(
                    hintText: 'Enter your email',
                    controller: regController.emailController,
                  ),
                  Gap(10.h),
                 
                  CustomTextField(
                    hintText: 'Enter your password',
                    controller: regController.passwordController,
                    isPassword: true,
                  ),
                  Gap(10.h),
                  CustomTextField(
                    hintText: 'Confirm password',
                    controller: regController.confirmPasswordController,
                    isPassword: true,
                  ),
                  Gap(15.h),
                  Obx(
                    () => Bounceable(
                      onTap: () async {
                        await imageController.pickImage();
                      },
                      child: Container(
                        width: double.infinity,
                        height: imageController.selectedImage.value != null ? 150.h : 50.h,
                        decoration: BoxDecoration(
                          color: imageController.selectedImage.value != null ? null : colorScheme.surface,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: colorScheme.onSurface),
                          image: imageController.selectedImage.value != null
                              ? DecorationImage(
                                  image: FileImage(imageController.selectedImage.value!),
                                  fit: BoxFit.contain,
                                )
                              : null,
                        ),
                        child: imageController.selectedImage.value != null
                            ? null
                            : Center(
                                child: Text(
                                  'Upload Image',
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Gap(20.h),
                  Obx(
                    () {
                      if (regController.isLoading.value) {
                      FocusScope.of(context).unfocus();
                      return  Center(child: CircularProgressIndicator(color:Get.theme.colorScheme.onPrimary,),);
                      } else {
                        return   PrimaryButton(
                      title: 'Sign Up',
                      onTap: () async {
                        // Set image in registration controller
                        regController.setImage(imageController.selectedImage.value);
                        // Call register function
                        await regController.register();

                        
                      },
                    );
                      }

                    }
                  ),
                  Gap(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: colorScheme.onBackground.withOpacity(0.7),
                          fontSize: 13.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

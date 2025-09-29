import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/auth/otp_verification_screen.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class RegistrationController extends GetxController {
  final ApiService _apiService = ApiService();

  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable for image
  final selectedImage = Rx<File?>(null);

  // Loading state
  final isLoading = false.obs;

  // Local storage


  void setImage(File? file) {
    selectedImage.value = file;
  }

  bool validate() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return false;
    }

    return true;
  }

  Future<bool> register() async {
    if (!validate()) return false;

    try {
      isLoading.value = true;

      final data = {
        'name': nameController.text,
        'email': emailController.text,
        //'address': addressController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      };

      final response = selectedImage.value != null
          ? await _apiService.postMultipart(
              ApiEndpoint.register,
              data,
              fileKey: 'image',
              file: selectedImage.value!,
            )
          : await _apiService.post(ApiEndpoint.register, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
       
        // Navigate to OTP screen
        Get.to(() =>  OtpVerificationScreen(type: 'registration', email: emailController.text,));
        return true;
      }
      return false;
    } catch (e) {
      // ApiService will already show error messages
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

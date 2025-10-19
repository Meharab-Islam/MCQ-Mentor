import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/auth/verify_mobile_login_otp_screen.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class MobileAuthController extends GetxController {
  final ApiService _apiService = ApiService();

  // Text controllers

  final phoneController = TextEditingController();

  // Observable for image
  final selectedImage = Rx<File?>(null);

  // Loading state
  final isLoading = false.obs;

  // Local storage

  bool validate() {
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return false;
    }

    return true;
  }

  Future<bool> register() async {
    if (!validate()) return false;

    try {
      isLoading.value = true;

      final data = {'phone': phoneController.text};

      final response = await _apiService.post(ApiEndpoint.phoneRegister, data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to OTP screen
        Get.to(()=> VerifyMobileLoginOtpScreen(phoneNumber: phoneController.text));
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
    phoneController.dispose();
    super.onClose();
  }
}

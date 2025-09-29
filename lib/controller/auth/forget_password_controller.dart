import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ForgotPasswordController extends GetxController {
  final ApiService _apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  Future<bool> sendResetLink() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Warning', 'Email cannot be empty');
      return false;
    }

    try {
      isLoading.value = true;

      final response = await _apiService.post(
        ApiEndpoint.forgotPassword,
        {"email": emailController.text},
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "OTP sent to your email");
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

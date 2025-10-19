import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class VerifyMobileLoginOtp extends GetxController {
  final ApiService _apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;

  final box = GetStorage();

  Future<void> login() async {
    if (phoneController.text.isEmpty || otpController.text.isEmpty) {
      Get.snackbar('Warning', 'Phone number and OTP cannot be empty');
      return;
    }

    try {
      isLoading.value = true;

      final user = {
        'phone': phoneController.text,
        'otp': otpController.text,
      };

      final response = await _apiService.post(ApiEndpoint.loginWithPhone, user);

      if (response.statusCode == 200) {
        final token = response.data['access_token'];

        if (token != null) {
          await box.write('access_token', token);
        }

        // Navigate to home
        Get.offAll(() => CustomBottomNavBarScreen());
      }
    } catch (e) {
      // ApiService will already show error messages
    } finally {
      isLoading.value = false;
    }
  }

  String? getToken() => box.read('access_token');

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}

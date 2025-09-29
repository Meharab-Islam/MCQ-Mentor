import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/screens/auth/login_screen.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  var isLoading = false.obs;

  /// Reset password logic
  Future<void> resetPassword(String email) async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final data = {
        "email": email,
        "password": newPassword,
        "password_confirmation": confirmPassword,
      };

      final response =
          await ApiService().post(ApiEndpoint.resetPassword, data);

      debugPrint("➡️ Request [POST] => PATH: ${ApiEndpoint.resetPassword}");
      debugPrint("flutter: Data: $data");
      debugPrint("✅ Response [${response.statusCode}] => ${response.data}");

      if (response.statusCode == 200 &&
          response.data['status'] == true) {


        // Navigate to login screen after successful reset
        Get.offAll(() => const LoginScreen());
      } else {
    debugPrint("Error");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}

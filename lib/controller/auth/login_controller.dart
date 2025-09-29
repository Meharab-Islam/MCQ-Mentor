import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

import '../../model/login_model.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;

  final box = GetStorage();

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Warning', 'Email and password cannot be empty');
      return;
    }

    try {
      isLoading.value = true;

      final user = LoginModel(
        email: emailController.text,
        password: passwordController.text,
      );

      final response = await _apiService.post(ApiEndpoint.login, user.toJson());

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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

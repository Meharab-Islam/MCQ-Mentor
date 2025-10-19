import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/screens/auth/login_screen.dart';
import 'package:mcq_mentor/screens/auth/reset_password_screen.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class OtpController extends GetxController {
  final ApiService _apiService = ApiService();

  // OTP input controller
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  // Countdown timer for resend
  final RxInt timer = 60.obs;
  final RxBool canResend = false.obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Email and type
  late String email;
  late String type;
  final box = GetStorage();

  /// Initialize controller with email + type
  void init(String userEmail, String flowType) {
    email = userEmail;
    type = flowType;
    startTimer();
  }

  /// Starts the countdown timer
  void startTimer() {
    canResend.value = false;
    timer.value = 60;

    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timer.value > 0) {
        timer.value--;
      } else {
        t.cancel();
        canResend.value = true;
      }
    });
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    try {
      isLoading.value = true;

      final data = {
        'email': email,
        'otp': int.tryParse(otpController.text) ?? 0,
      };

      final response = await _apiService.post(ApiEndpoint.verifyOtp, data);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP Verified Successfully');
        debugPrint('OTP verified: ${response.data}');

        if (type == "reset_password") {
          Get.offAll(() => ResetPasswordScreen(email: email,));
        } else {
          Get.offAll(() => const LoginScreen());
        }
      } else {
        Get.snackbar('Error', 'Invalid OTP: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error verifying OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    try {
      isLoading.value = true;

      final data = {'email': email};

      final response = await _apiService.post(ApiEndpoint.resendOtp, data);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP resent successfully');
        final token = response.data['access_token'];

        if (token != null) {
          await box.write('access_token', token);
        }

        startTimer();
      } else {
        Get.snackbar('Error', 'Failed to resend OTP: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error resending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}

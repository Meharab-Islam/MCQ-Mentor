import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mcq_mentor/model/profile/edit_profile_model.dart';
import 'package:mcq_mentor/model/profile/profile_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // reactive model for profile data
  final profile = EditProfileModel(
    name: '',
    address: '',
    dateOfBirth: '',
    phone: '',
    gender: 'male',
    image: '',
  ).obs;

  final imageFile = Rx<File?>(null);
  final picker = ImagePicker();

  // TextEditingControllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();

  final ApiService _apiService = ApiService();

  /// Load initial data from StudentProfile
  void setInitialData(StudentProfile userData) {
    // Convert DateTime to yyyy-MM-dd format for dobController
    final formattedDob = userData.dateOfBirth.toIso8601String().split('T').first;

    profile.value = EditProfileModel(
      name: userData.name,
      address: userData.address,
      dateOfBirth: formattedDob,
      phone: userData.phone,
      gender: userData.gender,
      image: userData.image,
    );

    nameController.text = userData.name;
    addressController.text = userData.address;
    dobController.text = formattedDob;
    phoneController.text = userData.phone;

    if (userData.image.isNotEmpty) {
      imageFile.value = File(userData.image);
    }
  }

  /// Pick image
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
      profile.update((val) {
        val?.image = picked.path;
      });
    }
  }

  /// Update gender
  void updateGender(String value) {
    profile.update((val) {
      val?.gender = value;
    });
  }

  /// Submit update to API
  Future<void> submitUpdate() async {
    if (!formKey.currentState!.validate()) return;

    // Update model from form fields
    profile.update((val) {
      val?.name = nameController.text.trim();
      val?.address = addressController.text.trim();
      val?.dateOfBirth = dobController.text.trim();
      val?.phone = phoneController.text.trim();
    });

    try {
      Map<String, dynamic> data = {
        "name": profile.value.name,
        "address": profile.value.address,
        "date_of_birth": profile.value.dateOfBirth,
        "phone": profile.value.phone,
        "gender": profile.value.gender,
      };

      final response = await _apiService.postMultipart(
        ApiEndpoint.editProfile, // <-- Your API endpoint
        data,
        fileKey: "image",
        file: imageFile.value,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update profile!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Error",
        "Something went wrong! ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    dobController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

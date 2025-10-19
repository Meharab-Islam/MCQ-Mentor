import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mcq_mentor/model/profile/edit_profile_model.dart';
import 'package:mcq_mentor/model/profile/profile_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:get_storage/get_storage.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final profile = EditProfileModel(
    name: '',
    address: '',
    dateOfBirth: '',
    phone: '',
    gender: 'male',
    image: '',
  ).obs;

  RxBool isLoading = false.obs;
  final imageFile = Rx<File?>(null);
  final picker = ImagePicker();

  // Text Controllers
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();

  /// Initialize profile data from existing user
  void setInitialData(StudentProfile userData) {
    final formattedDob = userData.dateOfBirth != null
        ? userData.dateOfBirth!.toIso8601String().split('T').first
        : '';

    profile.value = EditProfileModel(
      name: userData.name,
      address: userData.address ?? '',
      dateOfBirth: formattedDob,
      phone: userData.phone ?? '',
      gender: userData.gender ?? 'male',
      image: userData.image ?? '',
    );

    nameController.text = userData.name;
    addressController.text = userData.address ?? '';
    dobController.text = formattedDob;
    phoneController.text = userData.phone ?? '';
  }

  /// Pick profile image from gallery
  Future<void> pickImage() async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        imageFile.value = File(picked.path);
        profile.update((val) => val?.image = picked.path);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  /// Update gender
  void updateGender(String value) {
    profile.update((val) => val?.gender = value);
  }

  /// Submit updated profile (with Multipart if image exists)
  Future<void> submitUpdate() async {
   

    isLoading.value = true;

    profile.update((val) {
      val?.name = nameController.text.trim();
      val?.address = addressController.text.trim();
      val?.dateOfBirth = dobController.text.trim();
      val?.phone = phoneController.text.trim();
    });

    final fields = {
      "name": profile.value.name,
      "address": profile.value.address,
      "date_of_birth": profile.value.dateOfBirth,
      "phone": profile.value.phone,
      "gender": profile.value.gender,
    };

    final prefs = GetStorage();
    final token = prefs.read('access_token');

    final uri = Uri.parse(ApiEndpoint.editProfile);
    final request = http.MultipartRequest('POST', uri)..fields.addAll(fields);

    // Add image file if selected
    if (imageFile.value != null) {
      final file = imageFile.value!;
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
    }

    // Add headers
    request.headers['Accept'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to update profile. (${response.statusCode})\n$responseBody",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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

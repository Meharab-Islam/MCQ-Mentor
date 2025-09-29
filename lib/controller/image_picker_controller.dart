import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  // Observables for form input and image.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Function to pick and crop an image from the gallery.
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Pass the picked image to the cropping function.
      _cropImage(image.path);
    }
  }

  // Function to crop the image.
  Future<void> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Get.theme.colorScheme.primary,
            toolbarWidgetColor: Get.theme.colorScheme.onPrimary,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      selectedImage.value = File(croppedFile.path);
    }
  }

  // Dispose of controllers to prevent memory leaks.
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

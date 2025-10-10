import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/profile_section/edit_profile_controller.dart';
import 'package:mcq_mentor/model/profile/profile_model.dart';

class EditProfileScreen extends StatefulWidget {
  final StudentProfile userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  void initState() {
    super.initState();
    controller.setInitialData(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // === IMAGE PICKER ===
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    ImageProvider imageProvider;

                    // 🟢 1. If user picked new image
                    if (controller.imageFile.value != null) {
                      imageProvider = FileImage(controller.imageFile.value!);
                    }
                    // 🟢 2. If user already has image URL from server
                    else if (controller.profile.value.image.isNotEmpty) {
                      imageProvider = NetworkImage(
                        controller.profile.value.image,
                      );
                    }
                    // 🟢 3. If local file path exists (from offline)
                    else if (controller.profile.value.image.isNotEmpty &&
                        File(controller.profile.value.image).existsSync()) {
                      imageProvider = FileImage(
                        File(controller.profile.value.image),
                      );
                    }
                    // 🟢 4. Otherwise show default placeholder
                    else {
                      imageProvider = const NetworkImage(
                        "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
                      );
                    }

                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: controller.imageFile.value != null
                          ? FileImage(controller.imageFile.value!)
                          : controller.profile.value.image != null
                          ? NetworkImage(controller.profile.value.image)
                          : NetworkImage(
                              "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
                            ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),

                // === NAME ===
                _buildTextField(
                  label: "Name",
                  controller: controller.nameController,
                ),
                const SizedBox(height: 12),

                // === ADDRESS ===
                _buildTextField(
                  label: "Address",
                  controller: controller.addressController,
                ),
                const SizedBox(height: 12),

                // === DOB ===
                _buildTextField(
                  label: "Date of Birth",
                  controller: controller.dobController,
                  hintText: "YYYY-MM-DD",
                ),
                const SizedBox(height: 12),

                // === PHONE ===
                _buildTextField(
                  label: "Phone",
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                // === GENDER DROPDOWN ===
                DropdownButtonFormField<String>(
                  value: controller.profile.value.gender.isNotEmpty
                      ? controller.profile.value.gender
                      : "male",
                  decoration: const InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "male", child: Text("Male")),
                    DropdownMenuItem(value: "female", child: Text("Female")),
                    DropdownMenuItem(value: "others", child: Text("Others")),
                  ],
                  onChanged: (value) {
                    if (value != null) controller.updateGender(value);
                  },
                ),
                const SizedBox(height: 24),

                // === SUBMIT BUTTON ===
                ElevatedButton.icon(
                  onPressed: controller.submitUpdate,
                  icon: const Icon(Icons.save),
                  label: const Text("Update Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (val) => val!.isEmpty ? "Enter $label" : null,
    );
  }
}

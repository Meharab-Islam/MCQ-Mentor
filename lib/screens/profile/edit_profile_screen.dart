import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/profile_section/edit_profile_controller.dart';
import 'package:mcq_mentor/model/profile/profile_model.dart';
import 'package:mcq_mentor/widget/custom_appbar.dart';

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
    final mainColor = Get.theme.colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppbar(title: "Edit Profile"),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ===== Profile Image =====
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: mainColor.withOpacity(0.1),
                          backgroundImage: controller.imageFile.value != null
                              ? FileImage(controller.imageFile.value!)
                              : controller.profile.value.image.isNotEmpty
                              ? NetworkImage(controller.profile.value.image)
                              : const NetworkImage(
                                      "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg?semt=ais_hybrid&w=740&q=80",
                                    )
                                    as ImageProvider,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [mainColor, mainColor.withOpacity(0.8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ===== Name =====
                _buildTextField(
                  "Full Name",
                  controller.nameController,
                  mainColor,
                ),
                const SizedBox(height: 16),

                // ===== Address =====
                _buildTextField(
                  "Address",
                  controller.addressController,
                  mainColor,
                ),
                const SizedBox(height: 16),

                // ===== Date of Birth =====
                _buildTextField(
                  "Date of Birth",
                  controller.dobController,
                  mainColor,
                  hintText: "YYYY-MM-DD",
                  icon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(controller.dobController.text) ??
                          DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Get
                                  .theme
                                  .colorScheme
                                  .onPrimary, // header background color
                              onPrimary: Colors.white, // header text color
                              onSurface: Get
                                  .theme
                                  .colorScheme
                                  .onPrimary, // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Get
                                    .theme
                                    .colorScheme
                                    .onPrimary, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null) {
                      controller.dobController.text = pickedDate
                          .toIso8601String()
                          .split('T')
                          .first;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // ===== Phone =====
                _buildTextField(
                  "Phone",
                  controller.phoneController,
                  mainColor,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // ===== Gender Dropdown =====
                DropdownButtonFormField<String>(
                  value: controller.profile.value.gender,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: mainColor),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: mainColor, width: 2),
                    ),
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
                const SizedBox(height: 32),

                // ===== Submit Button =====
                SizedBox(
                  height: 50,
                  child: Obx(() {
                    return ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submitUpdate,
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save, size: 24),
                      label: Text(
                        controller.isLoading.value
                            ? "Updating..."
                            : "Update Profile",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.theme.colorScheme.onPrimary,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black45,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color mainColor, {
    TextInputType? keyboardType,
    String? hintText,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: mainColor) : null,
        labelStyle: TextStyle(color: mainColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor, width: 2),
        ),
      ),
    );
  }
}

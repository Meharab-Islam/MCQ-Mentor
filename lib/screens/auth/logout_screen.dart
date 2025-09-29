import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'login_screen.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  void _logout() async {
    final box = GetStorage();

    // Remove saved token
    await box.remove('access_token');

    // Navigate back to login screen and remove all previous routes
    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

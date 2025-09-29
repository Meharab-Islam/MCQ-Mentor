import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';
import 'package:mcq_mentor/screens/auth/logout_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo.png"), // ✅ put your logo here
            ),
            accountName: const Text("John Doe"),
            accountEmail: const Text("johndoe@example.com"),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to home
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text("Notifications"),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to notification screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),
                const Divider(),

                // Theme Toggle
                Obx(() => SwitchListTile(
                      secondary: Icon(
                        themeController.isDarkMode.value
                            ? Icons.dark_mode
                            : Icons.wb_sunny,
                      ),
                      title: const Text("Dark Mode"),
                      value: themeController.isDarkMode.value,
                      onChanged: (val) => themeController.toggleTheme(),
                    )),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                   Get.to(LogoutScreen());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

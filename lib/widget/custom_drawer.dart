import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';
import 'package:mcq_mentor/screens/auth/logout_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(ProfileController());
    ScreenUtil.init(context, designSize: const Size(375, 812));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24.r)),
      ),
      elevation: 8,
      backgroundColor: isDark
          ? const Color(0xFF1E1E2C)
          : const Color(0xFFF8F9FD), // base color

      child: Column(
        children: [
          // 🔹 HEADER SECTION (Compact & Stylish)
          
          Obx(() {
            final isLoading = profileController.isLoading.value;
            final student = profileController.studentProfile.value;
      
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF23283E), const Color(0xFF1B1F33)]
                      : [const Color(0xFF6DD5FA), const Color(0xFF2980B9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.r),
                  bottomRight: Radius.circular(16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile image with subtle animation
                  Gap(30.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40.r,
                      backgroundColor: Colors.white,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
                          : ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: student?.image.isNotEmpty == true
                                    ? student!.image
                                    : 'https://i.pinimg.com/564x/39/33/f6/3933f64de1724bb67264818810e3f2cb.jpg',
                                height: 80.h,
                                width: 80.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.person,
                                        color: Colors.white, size: 40),
                              ),
                            ),
                    ),
                  )
                      .animate()
                      .scale(duration: 500.ms, curve: Curves.easeOutBack)
                      .fadeIn(duration: 400.ms),
      
                  SizedBox(height: 10.h),
      
                  // User Name
                  Text(
                    isLoading ? "Loading..." : student?.name ?? 'Guest User',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    isLoading
                        ? "Please wait..."
                        : student?.email ?? 'No email found',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            );
          }),
      
          // 🔹 Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              children: [
                _drawerTile(
                  icon: Icons.home_rounded,
                  title: "Home",
                  delay: 0,
                  onTap: () => Navigator.pop(context),
                  isDark: isDark,
                ),
                
                _drawerTile(
                  icon: Icons.settings_rounded,
                  title: "Settings",
                  delay: 200,
                  onTap: () => Navigator.pop(context),
                  isDark: isDark,
                ),
                _drawerTile(
                  icon: Icons.workspace_premium_rounded,
                  title: "Premium Features",
                  delay: 300,
                  onTap: () {},
                  isDark: isDark,
                ),
                const Divider(
                  indent: 16,
                  endIndent: 16,
                  thickness: 0.6,
                ),
                _drawerTile(
                  icon: Icons.logout_rounded,
                  title: "Logout",
                  color: Colors.redAccent,
                  delay: 400,
                  onTap: () => Get.to(() => const LogoutScreen()),
                  isDark: isDark,
                ),
              ],
            ),
          ),
      
          // 🔹 Footer
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Text(
              "v1.0.0 • MCQ Mentor",
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey[600],
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDark = false,
    Color? color,
    int delay = 0,
  }) {
    final iconColor = color ?? (isDark ? Colors.white : Colors.black87);
    final textColor = color ?? (isDark ? Colors.white : Colors.black87);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        tileColor:
            isDark ? Colors.white.withOpacity(0.05) : Colors.blue[50]!.withOpacity(0.4),
        hoverColor: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.blueAccent.withOpacity(0.15),
        onTap: onTap,
      )
          .animate(delay: delay.ms)
          .slideX(begin: -0.3, duration: 400.ms, curve: Curves.easeOutCubic)
          .fadeIn(duration: 400.ms),
    );
  }
}

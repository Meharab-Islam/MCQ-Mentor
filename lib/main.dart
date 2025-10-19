import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/constant/colors.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/controller/auth/login_controller.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';
import 'package:mcq_mentor/controller/theme_controller.dart'; // ✅ new import
import 'package:mcq_mentor/firebase_options.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/utils/app_binding.dart';
import 'package:mcq_mentor/screens/auth/login_screen.dart';
import 'package:mcq_mentor/widget/logo_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await _initApp();

  runApp(const MyApp());
}

Future<void> _initApp() async {
  try {
    await GetStorage.init();
  } catch (e) {
    debugPrint('GetStorage init error: $e');
  }
  Get.put(ProfileController());
  Get.put(LoginController());
  Get.put(ThemeController()); // ✅ register theme controller
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return  GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
          
              // themeMode: themeController.theme, // ✅ reactive theme
              themeMode: ThemeMode.light, // ✅ reactive theme
              initialBinding: AppBinding(),
              home: const AuthCheckScreen(),
            );
      },
    );
  }
}




class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
  final LoginController loginController = Get.find<LoginController>();
    await Future.delayed(const Duration(seconds: 2)); // Optional splash delay
    final token = loginController.getToken();
    print("Access Token: $token");
     
    if (token != null) {
      // User is logged in, navigate to HomeScreen
      // Get.off(() => const CustomBottomNavBarScreen());
      Get.off(() => const CustomBottomNavBarScreen());
    } else {
      // User not logged in, navigate to LoginScreen
      Get.off(() => const LoginScreen()); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(
        child: LogoLoader(assetPath: AppImages.logo),
      ),
    );
  }
}

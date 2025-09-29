// app binding
import 'package:get/get.dart';
import 'package:mcq_mentor/controller/auth/login_controller.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register the AuthController as a dependency
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ThemeController>(()=> ThemeController());
  }
}
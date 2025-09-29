import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // reactive boolean
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromStorage();
  }

  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  void _saveThemeToStorage(bool isDarkMode) => _storage.write(_key, isDarkMode);

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToStorage(isDarkMode.value);
  }
}

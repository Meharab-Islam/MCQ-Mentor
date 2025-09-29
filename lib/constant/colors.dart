import 'package:flutter/material.dart';

/// Defines a set of colors for the light theme of the application.
/// These colors are based on the user's provided palette.
class AppColorsLight {
  static const Color primary = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryVariant = Color.fromARGB(255, 90, 90, 90);
  static const Color secondary = Color(0xFF14509d);
  static const Color secondaryVariant = Color(0xFF66809c);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color.fromARGB(255, 9, 39, 77);
  static const Color onSecondary = Color.fromARGB(255, 167, 200, 236);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);

  // Additional custom colors
  static const Color lightGray = Color(0xFFD3D3D3);
  static const Color darkGray = Color(0xFFA9A9A9);
  static const Color lightBlue = Color(0xFFADD8E6);
  static const Color darkBlue = Color(0xFF00008B);
}

/// Defines a set of colors for the dark theme of the application.
/// These colors are chosen to be visually appropriate for dark mode.
class AppColorsDark {
  static const Color primary = Color.fromARGB(255, 9, 39, 77);
  static const Color primaryVariant = Color.fromARGB(255, 9, 39, 77);
  static const Color secondary = Color(0xFF14509d);
  static const Color secondaryVariant = Color(0xFF66809c);
  static const Color background = Color.fromARGB(255, 9, 39, 77);
  static const Color surface = Color.fromARGB(255, 39, 71, 113);
  static const Color error = Color(0xFFCF6679);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFF000000);

  // Additional custom colors
  static const Color lightGray = Color(0xFF555555);
  static const Color darkGray = Color(0xFF333333);
  static const Color lightBlue = Color(0xFF00008B);
  static const Color darkBlue = Color(0xFFADD8E6);
}

/// A class that provides predefined light and dark themes for the app.
class AppTheme {
  /// The light theme for the application.
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      primary: AppColorsLight.primary,
      onPrimary: AppColorsLight.onPrimary,
      secondary: const Color.fromARGB(255, 199, 205, 213),
      onSecondary: const Color.fromARGB(255, 35, 87, 167),
      error: AppColorsLight.error,
      onError: AppColorsLight.onError,
      background: AppColorsLight.background,
      onBackground: AppColorsLight.onBackground,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.onSurface,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
  );

  /// The dark theme for the application.
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      error: AppColorsDark.error,
      onError: AppColorsDark.onError,
      background: AppColorsDark.background,
      onBackground: AppColorsDark.onBackground,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}

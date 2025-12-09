import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/controller/auth/login_controller.dart';
import 'package:mcq_mentor/controller/profile_section/profile_controller.dart';
import 'package:mcq_mentor/controller/theme_controller.dart';
import 'package:mcq_mentor/firebase_options.dart';
import 'package:mcq_mentor/utils/app_binding.dart';
import 'package:mcq_mentor/widget/logo_loader.dart';
import 'package:mcq_mentor/constant/images.dart';
import 'package:mcq_mentor/screens/auth/login_screen.dart';
import 'package:mcq_mentor/screens/home/CustomBottomNavBar.dart';
import 'package:mcq_mentor/constant/colors.dart';
// import 'package:no_screenshot/no_screenshot.dart';

/// -------- BACKGROUND FCM HANDLER --------
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 BG Message: ${message.messageId}');
}

/// -------- LOCAL NOTIFICATION PLUGIN --------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  const ios = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const settings = InitializationSettings(android: android, iOS: ios);

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (r) {
      debugPrint("🔔 Notification clicked: ${r.payload}");
    },
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();
  Get.lazyPut(() => ProfileController());
  Get.put(LoginController());
  Get.put(ThemeController());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initLocalNotifications();

  runApp(const MyApp());
}

/// -------- MAIN APP CLASS --------
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
// final _noScreenshot = NoScreenshot.instance;

// void disableScreenshot() async {
//   bool result = await _noScreenshot.screenshotOff();
//   debugPrint('Screenshot Off: $result');
// }
  @override
  void initState() {
    // disableScreenshot();
    super.initState();

    final login = Get.find<LoginController>();

    /// ✅ Only initialize FCM if user is logged in
    if (login.getToken() != null) {
      print("✅ User logged in → Initializing FCM...");
      _setupFCM();
    } else {
      print("⛔ User not logged in → Skipping FCM Registration");
    }
  }
Future<void> _setupFCM() async {
  _messaging = FirebaseMessaging.instance;

  // 1. Request permission (iOS only)
  await _messaging.requestPermission(alert: true, badge: true, sound: true);

  final profileController = Get.find<ProfileController>();

  // 2. Wait until profile is loaded
  ever(profileController.studentProfile, (profile) async {
    final profileId = profile?.id;
    if (profileId == null) return;

    final uid = profileId.toString();

    // ✅ IMPORTANT: If iOS → ensure APNS is ready
  if (Platform.isIOS) {
  String? apns;
  int retry = 0;

  while (apns == null && retry < 5) {
    apns = await _messaging.getAPNSToken();
    if (apns == null) {
      print("⚠️ Waiting for APNS token... attempt ${retry + 1}");
      await Future.delayed(const Duration(milliseconds: 500)); // WAIT 0.5 sec
      retry++;
    }
  }

  if (apns == null) {
    print("❌ APNS token still not available after retries");
    return; // Stop and wait until APNS is ready
  }

  print("🍏 APNS token ready: $apns");
}


    // 3. Get FCM token now (safe)
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null || fcmToken.isEmpty) {
      print("❌ Failed to get FCM token.");
      return;
    }

    print("🔥 FCM Token: $fcmToken");
    await _saveFcmTokenToLaravel(uid, fcmToken);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("♻️ FCM token refreshed: $newToken");
      await _saveFcmTokenToLaravel(uid, newToken);
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showLocalNotification(
          message.notification!.title ?? "Notification",
          message.notification!.body ?? "",
        );
      }
    });
  });
}


  /// -------- SAVE FCM TOKEN TO LARAVEL --------
  Future<void> _saveFcmTokenToLaravel(String uid, String fcmToken) async {
    try {
      print("📡 Sending → UID: $uid | FCM: $fcmToken");

      final dio = Dio(
        BaseOptions(
          baseUrl: "https://api.mcqmentor.com/mcq_web_app/public/api",
          headers: {"Accept": "application/json"},
        ),
      );

      final res = await dio.post("/save-fcm-token", data: {
        "user_id": uid,
        "fcm_token": fcmToken,
      });

      print(res.statusCode == 200
          ? "✅ Token saved to Laravel"
          : "⚠️ Failed to save token. Status: ${res.statusCode}");
    } catch (e) {
      print("❌ Error sending FCM token to Laravel: $e");
    }
  }

  /// -------- SHOW LOCAL NOTIFICATION --------
  Future<void> _showLocalNotification(String title, String body) async {
    const android = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: android),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => GetMaterialApp(
        title: "MCQ Mentor",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        initialBinding: AppBinding(),
        home: const AuthCheckScreen(),
      ),
    );
  }
}

/// -------- LOGIN CHECK SCREEN --------
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

  Future<void> _checkLogin() async {
    final login = Get.find<LoginController>();
    await Future.delayed(const Duration(seconds: 2));
    login.getToken() != null
        ? Get.off(() => const CustomBottomNavBarScreen())
        : Get.off(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Center(child: LogoLoader(assetPath: AppImages.logo)),
    );
  }
}

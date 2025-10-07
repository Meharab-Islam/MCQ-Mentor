import 'package:get/get.dart';
import 'package:mcq_mentor/model/notification/notification_model.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var expandedIndex = (-1).obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDummyNotifications();
  }

  /// Dummy data for local testing (no API)
  Future<void> fetchDummyNotifications() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading

    notifications.value = [
      NotificationModel(
        id: 1,
        title: "🎉 Welcome to MCQ Mentor!",
        description:
            "<p>We’re <b>excited</b> to have you on board! 🎓<br>Start exploring all our <i>premium questions</i> and features today.</p>",
      ),
      NotificationModel(
        id: 2,
        title: "🔥 New Subject Added: Physics Premium Pack",
        description:
            "<p>Our latest <b>Physics Premium Pack</b> is now live!<br>Includes detailed explanations, formula sheets, and live test modules.</p>",
      ),
      NotificationModel(
        id: 3,
        title: "⚡ Limited Time Offer",
        description:
            "<p>Get <span style='color:red; font-weight:bold;'>50% OFF</span> on all annual packages until <b>October 10</b>.<br>Don’t miss this chance to upgrade!</p>",
      ),
      NotificationModel(
        id: 4,
        title: "📢 App Update Available",
        description:
            "<p>Version <b>2.5.0</b> is now available!<br>Enjoy smoother performance, bug fixes, and a brand new dark mode 🌙.</p>",
      ),
      NotificationModel(
        id: 5,
        title: "🧠 Daily Quiz Reminder",
        description:
            "<p>Keep your streak going! 💪<br>Today’s quiz topic: <b>Chemical Bonding</b>.<br><i>Tap below to start your quiz now!</i></p>",
      ),
    ];

    isLoading(false);
  }

  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}

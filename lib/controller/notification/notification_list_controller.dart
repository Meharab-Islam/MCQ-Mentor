import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/model/notification/notification_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var expandedIndex = (-1).obs;
  var isLoading = true.obs;

  final ApiService _apiService = ApiService();
  final GetStorage _storage = GetStorage();
  final String _readIdsKey = 'read_notification_ids';

  /// Keep track of read IDs
  List<int> _readIds = [];

  /// Count of unread notifications
  int get unreadCount =>
      notifications.where((n) => !_readIds.contains(n.id)).length;

  @override
  void onInit() {
    super.onInit();
    _readIds = _storage.read<List<dynamic>>(_readIdsKey)?.cast<int>() ?? [];
    fetchNotifications();
  }

  /// Fetch notifications from API
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiEndpoint.notificationList);
      final data = response.data['data'] as List;

      final list = data.map((json) {
        final n = NotificationModel.fromJson(json);
        final isRead = _readIds.contains(n.id);
        return n.copyWith(isRead: isRead);
      }).toList();

      // 🔹 Sort unread to top
      list.sort((a, b) {
        if (!a.isRead && b.isRead) return -1;
        if (a.isRead && !b.isRead) return 1;
        return b.id.compareTo(a.id); // newest first
      });

      notifications.value = list;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notifications');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle expand/collapse
  void toggleExpand(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  /// Mark a notification as read
  void markAsRead(int index) {
    final n = notifications[index];
    if (!_readIds.contains(n.id)) {
      _readIds.add(n.id);
      _storage.write(_readIdsKey, _readIds);
      notifications[index] = n.copyWith(isRead: true);

      // 🔹 Resort unread to top
      final sorted = [...notifications];
      sorted.sort((a, b) {
        if (!a.isRead && b.isRead) return -1;
        if (a.isRead && !b.isRead) return 1;
        return b.id.compareTo(a.id);
      });
      notifications.value = sorted;
    }
  }
}

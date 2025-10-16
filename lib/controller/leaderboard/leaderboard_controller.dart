import 'package:get/get.dart';
import 'package:mcq_mentor/model/leaderboard/leaderboard_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class LeaderboardController extends GetxController {
  var leaderboard = <LeaderboardUser>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading.value = true;

      final response = await ApiService().get(ApiEndpoint.leaderboard);
      final data = LeaderboardModel.fromJson(response.data);

      // No sorting here — backend provides the correct order
      leaderboard.assignAll(data.data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load leaderboard: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

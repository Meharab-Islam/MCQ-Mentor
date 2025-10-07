import 'package:get/get.dart';
import 'package:mcq_mentor/model/profile/profile_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

@override
  void onInit() {
   fetchStudentProfile();
    super.onInit();
  }
  var isLoading = false.obs;
  var studentProfile = Rx<StudentProfile?>(null);
  

  /// Fetch student profile from API
  Future<void> fetchStudentProfile() async {
    try {
      isLoading(true);

      final response = await _apiService.get(ApiEndpoint.studentProfile);

      if (response.statusCode == 200) {
        if (response.data['status'] == true && response.data['data'] != null) {
          studentProfile.value = StudentProfile.fromJson(response.data['data']);
        } else {
          Get.snackbar('Error', response.data['message'] ?? 'Failed to load profile');
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to fetch profile: $e');
    } finally {
      isLoading(false);
    }
  }
}

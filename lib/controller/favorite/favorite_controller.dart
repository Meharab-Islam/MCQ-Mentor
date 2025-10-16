import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class FavoriteController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Message from API
  final RxString message = ''.obs;

  /// Favorite toggle function
  Future<void> toggleFavorite({
    required int sectionId,
    required int categoryId,
    required int archiveId,
    required int questionId,
  }) async {
    try {
      isLoading.value = true;
      message.value = '';

var pp = {
          'exam_section_id': sectionId,
          'exam_category_id': categoryId,
          'archive_id': archiveId,
          'question_id': questionId,
        };
        print(pp);
      // ✅ Call POST request using ApiService.post
      final response = await _apiService.post(
        ApiEndpoint.toggleFavorite, // your endpoint constant
        {}, // no body data, only query params
        queryParameters: {
          'exam_section_id': sectionId,
          'exam_category_id': categoryId,
          'archive_id': archiveId,
          'question_id': questionId,
        },
        needToken: true, // ✅ ensures token is added from storage
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        message.value = response.data['message'] ?? 'Favorite updated';
        Get.snackbar(
          'Favorite',
          message.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        message.value = 'Failed to update favorite';
        Get.snackbar(
          'Error',
          message.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      message.value = e.response?.data['message'] ?? 'Error toggling favorite';
      Get.snackbar(
        'Error',
        message.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

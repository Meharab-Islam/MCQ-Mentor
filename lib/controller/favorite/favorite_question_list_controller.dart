import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mcq_mentor/model/favorite/favorite_list_question_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class FavoriteListController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Message from API
  final RxString message = ''.obs;

  /// Favorites list
  final RxList<FavoriteQuestionModel> favorites = <FavoriteQuestionModel>[].obs;

  /// Pagination
  int currentPage = 1;
  bool hasNextPage = true;

  /// Fetch favorites
  Future<void> fetchFavorites({
    required int sectionId,
    required int categoryId,
    required int archiveId,
    int page = 1,
  }) async {
    if (!hasNextPage && page != 1) return;

    try {
      if (page == 1) {
        isLoading.value = true;
        favorites.clear();
      }

      final response = await _apiService.get(
        ApiEndpoint.favorites,
        queryParameters: {
          // 'exam_section_id': sectionId,
          // 'exam_category_id': categoryId,
          // 'archive_id': archiveId,
          'page': page,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'] as List;

        if (data.isEmpty) {
          hasNextPage = false;
        } else {
          hasNextPage = response.data['pagination']['next_page'] != null;
          currentPage = response.data['pagination']['current_page'] ?? page;

          // Parse JSON into model
          final questions = data
              .map((json) => FavoriteQuestionModel.fromJson(json))
              .toList();

          favorites.addAll(questions);
        }
      } else {
        message.value =
            response.data['message'] ?? 'Failed to fetch favorites';
        Get.snackbar('Error', message.value,
            snackPosition: SnackPosition.BOTTOM);
      }
    } on DioException catch (e) {
      message.value =
          e.response?.data['message'] ?? 'Failed to fetch favorites';
      Get.snackbar('Error', message.value,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove favorite (when unfavorited)
  Future<void> removeFavorite({
    required int questionId,
  }) async {
    try {

      // ✅ Remove from local list immediately
      favorites.removeWhere((item) => item.id == questionId);
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['message'] ?? 'Failed to remove favorite',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear favorites (for refresh)
  void clearFavorites() {
    favorites.clear();
    currentPage = 1;
    hasNextPage = true;
  }
}

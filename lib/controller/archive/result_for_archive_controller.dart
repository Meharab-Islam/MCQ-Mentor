import 'package:get/get.dart';
import 'package:mcq_mentor/model/archive/result_for_archive_model.dart';
import 'package:mcq_mentor/utils/api_services.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

class ResultForArchiveController extends GetxController {
  final ApiService _apiService = ApiService();

  final String examSectionId;
  final String examCategoryId;

  ResultForArchiveController({required this.examSectionId, required this.examCategoryId});

  var results = <ResultData>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchResults();
  }

  Future<void> fetchResults({bool isRefresh = false}) async {
    if (isLoading.value || isMoreLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      hasMore.value = true;
      results.clear();
    }

    isLoading.value = currentPage == 1;
    isMoreLoading.value = currentPage > 1;

    try {
      final response = await _apiService.get(
        ApiEndpoint.archiveResult,
        queryParameters: {'page': currentPage},
      );

      final data = ResultForArchive.fromJson(response.data);

      if (data.data.isEmpty) {
        hasMore.value = false;
      } else {
        if (isRefresh) {
          results.assignAll(data.data);
        } else {
          results.addAll(data.data);
        }
        currentPage++;
      }
    } catch (e) {
      print('Error fetching results for archive: $e');
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}

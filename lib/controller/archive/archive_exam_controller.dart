import 'package:get/get.dart';
import 'package:mcq_mentor/model/archive/archive_exam_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ArchiveExamController extends GetxController {
  final ApiService _apiService = ApiService();

  RxList<ArchiveExamModel> exams = <ArchiveExamModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  int totalPages = 1;



  /// Fetch archives from API with pagination
  Future<void> fetchArchives({int page = 1, required int examSectionId, required int examCategoryId}) async {
    isLoading.value = true;
    try {
    Map  queryParameters =  {
          "page": page.toString(),
          "limit_page": "10",
          "exam_section_id": examSectionId,
          "exam_category_id": examCategoryId,
        };
        print("querrypppp $queryParameters");

      final response = await _apiService.get(
        ApiEndpoint.archiveExamList, // from your endpoint file
        queryParameters: {
          "page": page.toString(),
          "limit_page": "10",
          "exam_section_id": examSectionId,
          "exam_category_id": examCategoryId,
        },
      );
      

      final result = response.data;

      if (result['success'] == true) {
        // ✅ Handle pagination
        final pagination = result['pagination'];
        totalPages = int.tryParse(pagination?['total_page'].toString() ?? '1') ?? 1;
        currentPage.value = page;

        // ✅ Parse data
        final List<dynamic> dataList = result['data'] ?? [];

        if (page == 1) exams.clear();
        exams.addAll(dataList.map((e) => ArchiveExamModel.fromJson(e)).toList());
      } else {
        print(result['message']);
      }
    } catch (e) {
     print(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Pagination controls
  void nextPage({required int examSectionId, required int examCategoryId}) {
    if (currentPage.value < totalPages) {
      fetchArchives(page: currentPage.value + 1, examSectionId: examSectionId, examCategoryId: examCategoryId);
    }
  }

  void previousPage({required int examSectionId, required int examCategoryId}) {
    if (currentPage.value > 1) {
      fetchArchives(page: currentPage.value - 1, examSectionId: examSectionId, examCategoryId: examCategoryId);
    }
  }

}

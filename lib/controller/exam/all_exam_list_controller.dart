import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/all_exam_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class AllExamListController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var examList = <ExamData>[].obs;

  // Pagination + filters
  var currentPage = 1;
  final int perPage = 10;
  int totalPage = 1;
  int subjectSearch = 5; // default subjectSearch value

  /// Fetch exams (for initial load or refresh)
  Future<void> fetchAllExams({bool refresh = true}) async {
    try {
      if (refresh) {
        isLoading.value = true;
        currentPage = 1;
      } else {
        isMoreLoading.value = true;
      }

      final response = await _apiService.get(
        ApiEndpoint.allExamList,
        queryParameters: {
          'page': currentPage.toString(),
          'per_page': perPage.toString(),
          'subjectSearch': subjectSearch.toString(),
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List data = response.data['data'];

        if (refresh) {
          examList.assignAll(data.map((e) => ExamData.fromJson(e)).toList());
        } else {
          examList.addAll(data.map((e) => ExamData.fromJson(e)).toList());
        }

        // Pagination info
        if (response.data['pagination'] != null) {
          totalPage = int.tryParse(
                  response.data['pagination']['total_page'].toString()) ??
              1;
        }
      } else {
       debugPrint(response.data);
      }
    } catch (e) {
     debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  /// Load next page automatically
  Future<void> loadNextPage() async {
    if (currentPage < totalPage && !isMoreLoading.value) {
      currentPage++;
      await fetchAllExams(refresh: false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllExams(); // auto load on start
  }
}

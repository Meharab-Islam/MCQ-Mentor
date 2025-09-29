import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/routine/all_routine_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class AllRoutineController extends GetxController {
  final ApiService _apiService = ApiService();

  /// Required params
  final String examSectionId;
  final String examCategoryId;

  AllRoutineController({
    required this.examSectionId,
    required this.examCategoryId,
  });

  /// Observables
  final isLoading = false.obs;
  final routines = <AllRoutine>[].obs;
  final pagination = Rxn<Pagination>();
  final errorMessage = RxnString();

  /// Pagination & filter params
  final currentPage = 1.obs;
  final int perPage = 20;
  final search = "".obs;

  /// Scroll controller for infinite scrolling
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchRoutines(isInitial: true);

    /// Infinite scroll listener
    scrollController.addListener(() {
      if (_shouldLoadMore()) {
        fetchRoutines();
      }
    });

    /// Debounce search input (avoid spam calls)
    debounce(search, (_) => fetchRoutines(isInitial: true),
        time: const Duration(milliseconds: 500));
  }

  /// Check if more data should be fetched
  bool _shouldLoadMore() {
    if (pagination.value?.nextPage == null) return false;
    if (isLoading.value) return false;
    if (!scrollController.hasClients) return false;

    return scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200;
  }

  /// Fetch routines from API
  Future<void> fetchRoutines({bool isInitial = false}) async {
    if (isLoading.value) return;

    if (isInitial) {
      currentPage.value = 1;
      routines.clear();
      errorMessage.value = null;
    }

    isLoading.value = true;

    try {
      final response = await _apiService.get(
        ApiEndpoint.allRoutine,
        queryParameters: {
          "page": currentPage.value,
          "per_page": perPage,
          "search": search.value,
          "exam_section_id": examSectionId,
          "exam_category_id": examCategoryId,
        },
      );

      if (response.statusCode == 200) {
        final model = AllRoutineResponse.fromJson(response.data);

        pagination.value = model.pagination;

        if (isInitial) {
          routines.assignAll(model.data);
        } else {
          routines.addAll(model.data);
        }

        // ✅ Update page for next fetch
        if (pagination.value?.nextPage != null) {
          currentPage.value = pagination.value!.nextPage!;
        }
      } else {
        errorMessage.value =
            "Failed to load routines (code: ${response.statusCode})";
      }
    } catch (e, st) {
      debugPrint("❌ Error fetching routines: $e");
      debugPrintStack(stackTrace: st);

      errorMessage.value =
          e.toString().contains("SocketException") ? "No Internet connection." : "Something went wrong. Please try again.";
    } finally {
      isLoading.value = false;
    }
  }

  /// Update search query (debounced)
  void setSearch(String value) {
    search.value = value;
  }

  /// Pull-to-refresh
  Future<void> refreshRoutines() async {
    await fetchRoutines(isInitial: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

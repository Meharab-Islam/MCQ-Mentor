// package_controller.dart
import 'package:get/get.dart';
import 'package:mcq_mentor/model/packages/package_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class PackageListController extends GetxController {
  var packages = <PackageListModel>[].obs;
  var isLoading = false.obs;
  var page = 1.obs;
  var totalPages = 1.obs; // total pages from API

  final int perPage = 10;
  final ApiService _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchPackages(pageNumber: 1);
  }

  /// Fetch packages with pagination
  Future<void> fetchPackages({int pageNumber = 1}) async {
    if (isLoading.value) return;

    try {
      isLoading(true);

      final queryParams = {
        'page': pageNumber.toString(),
        'per_page': perPage.toString(),
      };

      final response = await _api.get(
        ApiEndpoint.packageList,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<PackageListModel> fetchedPackages =
            (response.data['data'] as List)
                .map((json) => PackageListModel.fromJson(json))
                .toList();

        // Assign or append based on page
        if (pageNumber == 1) {
          packages.assignAll(fetchedPackages);
        } else {
          packages.addAll(fetchedPackages);
        }

        // Pagination info from API
        final pagination = response.data['pagination'];
        totalPages.value = pagination['total_page'] ?? 1;
        page.value = pagination['current_page'] ?? 1;
      }
    } catch (e) {
      print("Error fetching packages: $e");
      Get.snackbar('Error', 'Failed to fetch packages');
    } finally {
      isLoading(false);
    }
  }

  /// Load next page for infinite scrolling
  Future<void> loadNextPage() async {
    if (page.value < totalPages.value) {
      await fetchPackages(pageNumber: page.value + 1);
    }
  }

  /// Refresh packages
  Future<void> refreshPackages() async {
    packages.clear();
    page.value = 1;
    await fetchPackages(pageNumber: 1);
  }
}

import 'package:get/get.dart';
import 'package:mcq_mentor/model/pdf/all_category_list_for_pdf_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class AllCategoryListForPdfController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var categoryList = <AllCategoryListForPdf>[].obs;

  /// Fetch all categories for PDF
  Future<void> fetchAllCategoriesForPdf() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(ApiEndpoint.allCategoryListForPdf);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'] ?? [];
        categoryList.assignAll(
          data.map((e) => AllCategoryListForPdf.fromJson(e)).toList(),
        );
      } else {
       
      }
    } catch (e) {
    print(e);
    } finally {
      isLoading.value = false;
    }
  }
}

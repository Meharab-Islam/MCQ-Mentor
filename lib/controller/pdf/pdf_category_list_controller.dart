import 'package:get/get.dart';
import 'package:mcq_mentor/model/pdf/pdf_category_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class PDFCategoryController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var pdfTitles = <PDFCategory>[].obs;

  Future<void> fetchPDFs() async {
    try {
      isLoading(true);
      final response = await _apiService.get(ApiEndpoint.subjectList);

      if (response.statusCode == 200) {
        final parsedResponse = PDFCategoryResponse.fromJson(response.data);
        pdfTitles.assignAll(parsedResponse.data);
      } else {
        Get.snackbar('Error', 'Failed to load PDFs');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to fetch subjects: $e');
    } finally {
      isLoading(false);
    }
  }
}

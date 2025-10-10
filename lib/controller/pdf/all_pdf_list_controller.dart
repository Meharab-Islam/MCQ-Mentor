import 'package:get/get.dart';
import 'package:mcq_mentor/model/pdf/all_pdf_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class PdfController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var pdfList = <PdfFile>[].obs;

  Future<void> fetchPdfList(int categoryId) async {
    try {
      isLoading(true);

      final response = await _apiService.get(ApiEndpoint.allPDF, queryParameters: {
        "exam_category_id": categoryId,
      });

      if (response.statusCode == 200) {
        final parsedResponse = PdfResponse.fromJson(response.data);
        pdfList.assignAll(parsedResponse.data);
      } else {
        Get.snackbar('Error', 'Failed to load PDF list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to fetch PDF list: $e');
    } finally {
      isLoading(false);
    }
  }
}

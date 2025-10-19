import 'package:get/get.dart';
import 'package:mcq_mentor/model/pdf/all_pdf_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class PdfController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var pdfList = <PdfFile>[].obs;

  Future<void> fetchPdfList(String categoryId, String examSectionId) async {
    try {
      isLoading(true);

      final response = await _apiService.get(ApiEndpoint.allPDF, queryParameters: {
        "exam_category_id": categoryId,
        "exam_section_id": examSectionId,
      });

      if (response.statusCode == 200) {
        final parsedResponse = PdfResponse.fromJson(response.data);
        pdfList.assignAll(parsedResponse.data);
      } else {
       print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching PDF list: $e');
    } finally {
      isLoading(false);
    }
  }
}

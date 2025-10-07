import 'package:get/get.dart';
import 'package:mcq_mentor/model/category_section/single_category_details_model.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';

import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class SingleCategoryDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<SingleCategoryDetailsModel?> examSections =
      Rx<SingleCategoryDetailsModel?>(null);

  final RxBool isLoading = false.obs;

  Future<void> fetchExamSections(String categoryId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(
        "${ApiEndpoint.singleCategoryDetails}$categoryId",
      );

      if (response.statusCode == 200) {
        examSections.value = SingleCategoryDetailsModel.fromJson(response.data);
      print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb$categoryId");
      Get.to(()=> WeeklyModelTestScreen(
         pdf: examSections.value!.pdf,
        examSectionId: examSections.value!.data.id.toString(),
        examCategoryId: categoryId,
        title: examSections.value!.data.name,
       description: examSections.value!.data.description,
      ));
      }
    } catch (e) {
      print("Error fetching exam sections: $e");
    } finally {
      isLoading.value = false;
    }
  }
  
}

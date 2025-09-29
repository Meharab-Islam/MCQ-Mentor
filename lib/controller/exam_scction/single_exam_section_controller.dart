import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam_section/single_exam_section_model.dart';
import 'package:mcq_mentor/screens/home/category_section/category_section_list_screen.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class SingleExamSectionController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<SingleExamDetailsResponse?> examSections =
      Rx<SingleExamDetailsResponse?>(null);

  final RxBool isLoading = false.obs;

  Future<void> fetchExamSections(String examId) async {
    isLoading.value = true;
    try {
      final response = await _apiService.get(
        "${ApiEndpoint.singleExamSection}$examId",
      );

      if (response.statusCode == 200) {
        examSections.value = SingleExamDetailsResponse.fromJson(response.data);
      // print(examSections.value!.data.examItemLists.length);
      }
    } catch (e) {
      print("Error fetching exam sections: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    // React to loading state
    ever(isLoading, (loading) {
      if (loading == false) {
        // Close loader if open
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        // Navigate based on response
        if (examSections.value?.category != true) {
          Get.to(() => WeeklyModelTestScreen(
             examSectionId: examSections.value!.data.id.toString(),
        examCategoryId: '',
            title: examSections.value!.data.name.toString(),
            description: examSections.value!.data.description.toString(),
          ));
        } else {
          Get.to(() => CategorySectionListScreen(
            examSectionId: examSections.value!.data.id,
          ));
        }
      }
    });
  }
}

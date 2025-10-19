import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcq_mentor/model/category_section/single_category_details_model.dart';
import 'package:mcq_mentor/screens/home/weekly_model_test/weekly_model_test_screen.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class SingleCategoryDetailsController extends GetxController {
  final ApiService _apiService = ApiService();

  final String examSectionId;
  
  SingleCategoryDetailsController({required this.examSectionId});

  final Rx<SingleCategoryDetailsModel?> examSections =
      Rx<SingleCategoryDetailsModel?>(null);

  final RxBool isLoading = false.obs;

  Future<void> fetchExamSections(String categoryId) async {
    try {
      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false, // prevent back press
          child:  Center(
            child: CircularProgressIndicator(color: Get.theme.colorScheme.onPrimary,),
          ),
        ),
        barrierDismissible: false,
      );

      final response = await _apiService.get(
        "${ApiEndpoint.singleCategoryDetails}$categoryId",
      );

      if (response.statusCode == 200) {
        examSections.value = SingleCategoryDetailsModel.fromJson(response.data);
        print("Fetched category details for $categoryId");

        // Close loading dialog
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
 print("afasfasfhsajkfasdkjfadklsjfdisjfklsjfklsdjfikdsjfdklsjfsdkljfklsd${examSections.value!.data.id.toString()}");
        // Navigate to next screen
        Get.to(() => WeeklyModelTestScreen(
              pdf: examSections.value!.pdf,
              examSectionId: examSectionId,
              examCategoryId: categoryId,
              title: examSections.value!.data.name,
            ));
      } else {
        // Close dialog if error
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar('Error', 'Failed to fetch data',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("Error fetching exam sections: $e");
      Get.snackbar('Error', 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

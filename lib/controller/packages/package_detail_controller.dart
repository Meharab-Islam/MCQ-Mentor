// package_detail_controller.dart
import 'package:get/get.dart';
import 'package:mcq_mentor/model/packages/package_details_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class PackageDetailController extends GetxController {
  var isLoading = true.obs;
  var packageDetail = Rxn<PackageDetailModel>();

  final ApiService _api = ApiService();

  Future<void> fetchPackageDetail(int id) async {
    try {
      isLoading(true);
      final response = await _api.get("${ApiEndpoint.packageDetail}/$id");

      if (response.statusCode == 200 && response.data['data'] != null) {
        packageDetail.value =
            PackageDetailModel.fromJson(response.data['data']);
      } else {
        Get.snackbar('Error', 'Failed to load package details');
      }
    } catch (e) {
      print("Error fetching package details: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading(false);
    }
  }
}

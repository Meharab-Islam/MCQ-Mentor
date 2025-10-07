import 'package:get/get.dart';
import 'package:mcq_mentor/model/subject/subject_list_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class SubjectListController extends GetxController {
  var isLoading = true.obs;
  var sections = <SubjectListModel>[].obs;

  /// selectedSectionId = 0 means "All"
  var selectedSectionId = 0.obs;

  final ApiService _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchSections();
  }

  /// Fetch all sections
  Future<void> fetchSections() async {
    try {
      isLoading(true);

      final response = await _api.get(ApiEndpoint.subjectList);

      if (response.statusCode == 200 && response.data['data'] != null) {
        sections.value = (response.data['data'] as List)
            .map((json) => SubjectListModel.fromJson(json))
            .toList();

        // Default selection: "All" = 0
        selectedSectionId.value = 0;
      }
    } catch (e) {
      print("Error fetching sections: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Select a section
  void selectSection(int id) {
    selectedSectionId.value = id;
    print("Selected Section ID: $id");
  }

  /// Get the currently selected section object
  SubjectListModel? get selectedSection {
    if (selectedSectionId.value == 0) return null; // "All"
    return sections.firstWhereOrNull((s) => s.id == selectedSectionId.value);
  }
}

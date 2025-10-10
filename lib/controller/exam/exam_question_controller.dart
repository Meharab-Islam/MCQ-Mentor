import 'package:get/get.dart';
import 'package:mcq_mentor/model/exam/exam_question_model.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';
import 'package:mcq_mentor/utils/api_services.dart';

class ExamQuestionController extends GetxController {
  var isLoading = true.obs;
  var examData = Rxn<ExamQuestionModel>();

  // Store all questions and filtered questions
  var allQuestions = <Question>[].obs;
  var filteredQuestions = <Question>[].obs;

  Future<void> fetchExamQuestions(int examId) async {
    try {
      isLoading(true);
      final response = await ApiService().get("${ApiEndpoint.examQuestions}$examId");

      if (response.statusCode == 200 && response.data != null) {
        final data = ExamQuestionModel.fromJson(response.data);
        examData.value = data;

        // Flatten all questions from all subjects
        allQuestions.assignAll(
          data.subjects.expand((subject) => subject.questions).toList(),
        );

        // Initially, show all questions
        filteredQuestions.assignAll(allQuestions);
      }
    } catch (e) {
      print("🚨 Error fetching exam questions: $e");
    } finally {
      isLoading(false);
    }
  }

void filterQuestionsBySubject(int subjectId) {
  if (subjectId == 0) {
    // Show all questions
    filteredQuestions.assignAll(allQuestions);
  } else {
    // Find the matching subject
    final subject = examData.value?.subjects
        .firstWhereOrNull((s) => s.subjectId == subjectId);

    if (subject != null) {
      // Assign only that subject's questions
      filteredQuestions.assignAll(subject.questions);
    } else {
      // No subject found — empty list
      filteredQuestions.clear();
    }
  }

  print("Filtered questions: ${filteredQuestions.length}");
}

}

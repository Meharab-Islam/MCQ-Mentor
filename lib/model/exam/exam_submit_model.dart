class ExamSubmitPostModel {
  final int examId;
  final String answers;

  ExamSubmitPostModel({
    required this.examId,
    required this.answers,
  });

  /// Convert model to JSON for POST
  Map<String, dynamic> toJson() {
    return {
      "exam_id": examId,
      "answers": answers,
    };
  }
}

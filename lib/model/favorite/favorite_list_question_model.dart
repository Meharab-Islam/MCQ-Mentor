class FavoriteQuestionModel {
  final int id;
  final String userId;
  final String archiveId;
  final String examSectionId;
  final String examCategoryId;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String status;
  bool favorite; // For UI display

  FavoriteQuestionModel({
    required this.id,
    required this.userId,
    required this.archiveId,
    required this.examSectionId,
    required this.examCategoryId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.status,
    this.favorite = true, // default as favorite
  });

  factory FavoriteQuestionModel.fromJson(Map<String, dynamic> json) {
    return FavoriteQuestionModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      archiveId: json['archive_id'] ?? '',
      examSectionId: json['exam_section_id'] ?? '',
      examCategoryId: json['exam_category_id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['option'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      explanation: json['explanation'] ?? '',
      status: json['status'] ?? '',
      favorite: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'archive_id': archiveId,
      'exam_section_id': examSectionId,
      'exam_category_id': examCategoryId,
      'question': question,
      'option': options,
      'correct_answer': correctAnswer,
      'explanation': explanation,
      'status': status,
      'favorite': favorite,
    };
  }
}

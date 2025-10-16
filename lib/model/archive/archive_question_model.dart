class ArchiveQuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String template;
  bool favorite;

  /// Added subjectId to filter questions later
  int subjectId;

  ArchiveQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.template,
    required this.favorite,
    this.subjectId = 0,
  });

  factory ArchiveQuestionModel.fromJson(Map<String, dynamic> json) {
    return ArchiveQuestionModel(
      id: json['id'],
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      explanation: json['explanation'] ?? '',
      template: json['template'] ?? 'bangla',
      favorite: json['favorite'] ?? false,
      // subjectId will be set separately in the controller after parsing
      subjectId: 0,
    );
  }

  /// Convert to JSON if needed
  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options,
        'correct_answer': correctAnswer,
        'explanation': explanation,
        'template': template,
        'favorite': favorite,
        'subject_id': subjectId,
      };
}

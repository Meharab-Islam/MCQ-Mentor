import 'dart:convert';

class Question {
  final int id;
  final int subjectId;
  final String question;
  final String template;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String status;

  Question({
    required this.id,
    required this.subjectId,
    required this.question,
    required this.template,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.status,
  });

factory Question.fromJson(Map<String, dynamic> json) {
  return Question(
    id: json['id'] is String ? int.parse(json['id']) : json['id'],
    subjectId: json['subject_id'] is String ? int.parse(json['subject_id']) : json['subject_id'],
    question: json['question'] ?? '',
    template: json['template'] ?? '',
    options: List<String>.from(json['options'] ?? []),
    correctAnswer: json['correct_answer'] ?? '',
    explanation: json['explanation'] ?? '',
    status: json['status'] ?? '',
  );
}


  static List<Question> fromJsonList(String jsonString) {
    final data = json.decode(jsonString)['data'] as List;
    return data.map((e) => Question.fromJson(e)).toList();
  }
}

import 'package:get/get.dart';

class ExamQuestionModel {
  final String message;
  final int examId;
  final String examName;
  final List<SubjectQuestion> subjects;

  ExamQuestionModel({
    required this.message,
    required this.examId,
    required this.examName,
    required this.subjects,
  });

  factory ExamQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamQuestionModel(
      message: json['message'] ?? '',
      examId: json['exam_id'] ?? 0,
      examName: json['exam_name'] ?? '',
      subjects: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SubjectQuestion.fromJson(e))
          .toList(),
    );
  }
}

class SubjectQuestion {
  final int subjectId;
  final List<Question> questions;

  SubjectQuestion({
    required this.subjectId,
    required this.questions,
  });

  factory SubjectQuestion.fromJson(Map<String, dynamic> json) {
    return SubjectQuestion(
      subjectId: json['subject_id'] ?? 0,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}

class Question {
  final int id;
  final String question;
  final List<String> options;
  final String template;
  RxString selectedOption = ''.obs; // ✅ make reactive

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.template,
    String? selectedOption,
  }) {
    this.selectedOption.value = selectedOption ?? '';
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      template: json['template'] ?? '',
      selectedOption: json['selectedOption'],
    );
  }

  void selectOption(String option) {
    if (options.contains(option)) selectedOption.value = option;
  }
}


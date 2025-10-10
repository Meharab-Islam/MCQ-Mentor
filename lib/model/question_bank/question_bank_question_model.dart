// question_bank_question_model.dart
class QuestionBankQuestion {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String template;
  final String status;

  QuestionBankQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.template,
    required this.status,
  });

  factory QuestionBankQuestion.fromJson(Map<String, dynamic> json) {
    return QuestionBankQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'],
      explanation: json['explanation'],
      template: json['template'],
      status: json['status'],
    );
  }
}

class QuestionBankQuestionResponse {
  final List<QuestionBankQuestion> data;
  final int currentPage;
  final int totalPages;

  QuestionBankQuestionResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  factory QuestionBankQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionBankQuestionResponse(
      data: (json['data'] as List)
          .map((e) => QuestionBankQuestion.fromJson(e))
          .toList(),
      currentPage: json['pagination']['current_page'] ?? 1,
      totalPages: json['pagination']['total_page'] ?? 1,
    );
  }
}

// question_bank_exam_result_model.dart

class QuestionBankExamResultModel {
  final String message;
  final QuestionBankExamResultData result;
  final bool success;

  QuestionBankExamResultModel({
    required this.message,
    required this.result,
    this.success = true,
  });

  factory QuestionBankExamResultModel.fromJson(Map<String, dynamic> json) {
    return QuestionBankExamResultModel(
      message: json['message'] ?? '',
      result: json['result'] != null
          ? QuestionBankExamResultData.fromJson(json['result'])
          : QuestionBankExamResultData.empty(),
      success: json['success'] ?? true,
    );
  }
}

class QuestionBankExamResultData {
  final int totalQuestions;
  final int totalMarks;
  final int correctAnswers;
  final int wrongAnswers;
  final int notAnswered;
  final double obtainedMarks;
  final String negativeMarkPerWrong;
  final double totalNegativeMarks;
  final List<QuestionBankQuestionResult> details;

  QuestionBankExamResultData({
    required this.totalQuestions,
    required this.totalMarks,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswered,
    required this.obtainedMarks,
    required this.negativeMarkPerWrong,
    required this.totalNegativeMarks,
    required this.details,
  });

  /// Empty constructor for safe default
  factory QuestionBankExamResultData.empty() {
    return QuestionBankExamResultData(
      totalQuestions: 0,
      totalMarks: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      notAnswered: 0,
      obtainedMarks: 0.0,
      negativeMarkPerWrong: '0',
      totalNegativeMarks: 0.0,
      details: [],
    );
  }

  factory QuestionBankExamResultData.fromJson(Map<String, dynamic> json) {
    return QuestionBankExamResultData(
      totalQuestions: json['total_questions'] ?? 0,
      totalMarks: json['total_marks'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      wrongAnswers: json['wrong_answers'] ?? 0,
      notAnswered: json['not_answered'] ?? 0,
      obtainedMarks: (json['obtained_marks'] ?? 0).toDouble(),
      negativeMarkPerWrong: json['negative_mark_per_wrong']?.toString() ?? '0',
      totalNegativeMarks: (json['total_negative_marks'] ?? 0).toDouble(),
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => QuestionBankQuestionResult.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class QuestionBankQuestionResult {
  final int questionId;
  final String question; // HTML content supported
  final List<String> options; // HTML content for each option
  final String? selectedAnswer;
  final String correctAnswer;
  final String result; // correct / wrong / not answered

  QuestionBankQuestionResult({
    required this.questionId,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.result,
  });

  factory QuestionBankQuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionBankQuestionResult(
      questionId: json['question_id'] ?? 0,
      question: json['question']?.toString() ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      selectedAnswer: json['selected_answer']?.toString(),
      correctAnswer: json['correct_answer']?.toString() ?? '',
      result: json['result']?.toString() ?? '',
    );
  }
}

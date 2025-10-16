class ExamResultModel {
  final bool success;
  final String message;
  final ExamResultData? data;

  ExamResultModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '', // Convert to string safely
      data: json['data'] != null ? ExamResultData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ExamResultData {
  final String userId;
  final String totalQuestions;
  final String answeredQuestions;
  final String correctAnswers;
  final String wrongAnswers;
  final String notAnswered;
  final String negativeMarksPerWrong;
  final String totalNegativeMarks;
  final String totalMarksAfterNegativeMarkings;
  final String passMarks;

  ExamResultData({
    required this.userId,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswered,
    required this.negativeMarksPerWrong,
    required this.totalNegativeMarks,
    required this.totalMarksAfterNegativeMarkings,
    required this.passMarks,
  });

  factory ExamResultData.fromJson(Map<String, dynamic> json) {
    return ExamResultData(
      userId: json['user_id'] ?? "0",
      totalQuestions: json['total_questions'] ?? "0",
      answeredQuestions: json['answered_questions'] ?? "0",
      correctAnswers: json['correct_answers'] ?? "0",
      wrongAnswers: json['wrong_answers'] ?? "0",
      notAnswered: json['not_answered'] ?? "0",
      negativeMarksPerWrong: json['negative_marks_per_wrong'] ?? "0",
      totalNegativeMarks: json['total_negative_marks'] ?? "0",
      totalMarksAfterNegativeMarkings: json['total_marks_after_negative_markings'] ?? "0",
      passMarks: json['pass_marks']?? "0",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'total_questions': totalQuestions,
      'answered_questions': answeredQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'not_answered': notAnswered,
      'negative_marks_per_wrong': negativeMarksPerWrong,
      'total_negative_marks': totalNegativeMarks,
      'total_marks_after_negative_markings': totalMarksAfterNegativeMarkings,
      'pass_marks': passMarks,
    };
  }
}


// {success: true, message: false, data: {user_id: 4, total_questions: 2, answered_questions: 1, correct_answers: 0, wrong_answers: 1, not_answered: 1, cut_mark_per_wrong: 0.25, total_cut_marks: 0.25, total_marks_after_cut: -0.25}}
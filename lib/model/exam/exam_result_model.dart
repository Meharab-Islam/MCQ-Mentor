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
  final int userId;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int notAnswered;
  final double cutMarkPerWrong;
  final double totalCutMarks;
  final double totalMarksAfterCut;

  ExamResultData({
    required this.userId,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswered,
    required this.cutMarkPerWrong,
    required this.totalCutMarks,
    required this.totalMarksAfterCut,
  });

  factory ExamResultData.fromJson(Map<String, dynamic> json) {
    return ExamResultData(
      userId: json['user_id'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      answeredQuestions: json['answered_questions'] ?? 0,
      correctAnswers: json['correct_answers'] ?? 0,
      wrongAnswers: json['wrong_answers'] ?? 0,
      notAnswered: json['not_answered'] ?? 0,
      cutMarkPerWrong: (json['cut_mark_per_wrong'] ?? 0).toDouble(),
      totalCutMarks: (json['total_cut_marks'] ?? 0).toDouble(),
      totalMarksAfterCut: (json['total_marks_after_cut'] ?? 0).toDouble(),
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
      'cut_mark_per_wrong': cutMarkPerWrong,
      'total_cut_marks': totalCutMarks,
      'total_marks_after_cut': totalMarksAfterCut,
    };
  }
}


// {success: true, message: false, data: {user_id: 4, total_questions: 2, answered_questions: 1, correct_answers: 0, wrong_answers: 1, not_answered: 1, cut_mark_per_wrong: 0.25, total_cut_marks: 0.25, total_marks_after_cut: -0.25}}
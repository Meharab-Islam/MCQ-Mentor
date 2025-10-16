class ResultForArchive {
  final String? message;
  final List<ResultData> data;

  ResultForArchive({
    this.message,
    required this.data,
  });

  factory ResultForArchive.fromJson(Map<String, dynamic> json) {
    return ResultForArchive(
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ResultData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ResultData {
  final String examId;
  final String examName;
  final String examDescription;
  final String examDate;
  final String duration;
  final String totalMarks;
  final bool submitted;
  final String obtainedMarks;
  final String correctAnswers;
  final String wrongAnswers;
  final String notAnswered;
  final String totalQuestions;
  final String negativeMarkPerWrong;
  final String totalNegativeMarks;

  ResultData({
    required this.examId,
    required this.examName,
    required this.examDescription,
    required this.examDate,
    required this.duration,
    required this.totalMarks,
    required this.submitted,
    required this.obtainedMarks,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswered,
    required this.totalQuestions,
    required this.negativeMarkPerWrong,
    required this.totalNegativeMarks,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      examId: json['exam_id'],
      examName: json['exam_name'],
      examDescription: json['exam_description'] ?? '',
      examDate: json['exam_date'] ?? '',
      duration: json['duration'] ?? '0',
      totalMarks: json['total_marks'] ?? '0',
      submitted: json['submitted'] ?? false,
      obtainedMarks: json['obtained_marks'] ?? '0.00',
      correctAnswers: json['correct_answers'] ?? '0',
      wrongAnswers: json['wrong_answers'] ?? '0',
      notAnswered: json['not_answered'] ?? '0',
      totalQuestions: json['total_questions'] ?? '0',
      negativeMarkPerWrong: json['negative_mark_per_wrong'] ?? '0.00',
      totalNegativeMarks: json['total_negative_marks'] ?? '0.00',
    );
  }
}

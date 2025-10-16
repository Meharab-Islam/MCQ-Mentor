class TodaysActivitiesModel {
  final bool success;
  final String message;
  final TodayExamSummary data;

  TodaysActivitiesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TodaysActivitiesModel.fromJson(Map<String, dynamic> json) {
    return TodaysActivitiesModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: TodayExamSummary.fromJson(json['data'] ?? {}),
    );
  }
}

class TodayExamSummary {
  final String totalExams;
  final String submittedExams;
  final String totalMarks; // ✅ use double, not Double
  final String totalDuration;
  final String remainingExams;
  final List<TodayExamData> exams;

  TodayExamSummary({
    required this.totalExams,
    required this.submittedExams,
    required this.totalMarks,
    required this.totalDuration,
    required this.remainingExams,
    required this.exams,
  });

  factory TodayExamSummary.fromJson(Map<String, dynamic> json) {
    return TodayExamSummary(
      totalExams: json['total_exams'] ?? "0",
      submittedExams: json['submitted_exams'] ?? "0",
      totalMarks: (json['total_marks'] ?? "0"), // ✅ convert to double
      totalDuration: json['total_duration'] ?? "0",
      remainingExams: json['remaining_exams'] ?? "0",
      exams: (json['exams'] as List<dynamic>?)
              ?.map((e) => TodayExamData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TodayExamData {
  final int id;
  final String examName;
  final String examDescription;
  final String examDate;
  final String status;
  final String duration;
  final String? totalMark;
  final bool submitted;

  TodayExamData({
    required this.id,
    required this.examName,
    required this.examDescription,
    required this.examDate,
    required this.status,
    required this.duration,
    this.totalMark,
    required this.submitted,
  });

  factory TodayExamData.fromJson(Map<String, dynamic> json) {
    return TodayExamData(
      id: json['id'] ?? 0,
      examName: json['exam_name'] ?? '',
      examDescription: json['exam_description'] ?? '',
      examDate: json['exam_date'] ?? '',
      status: json['status'] ?? '',
      duration: json['duration'] ?? "",
      totalMark: json['total_mark'],
      submitted: json['submitted'] ?? false,
    );
  }
}

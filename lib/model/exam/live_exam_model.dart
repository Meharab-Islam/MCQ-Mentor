// live_exam_model.dart
class LiveExamModel {
  final bool success;
  final String message;
  final String date;
  final List<LiveExamData> data;

  LiveExamModel({
    required this.success,
    required this.message,
    required this.date,
    required this.data,
  });

  factory LiveExamModel.fromJson(Map<String, dynamic> json) {
    return LiveExamModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      data: json['data'] != null
          ? List<LiveExamData>.from(
              (json['data'] as List).map((x) => LiveExamData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'date': date,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class LiveExamData {
  final int id;
  final String examName;
  final String examDescription;
  final String examSectionId;
  final String? examCategoryId;
  final String duration;
  final String totalMarks;
  final String cutMarks;
  final String examDate;
  final bool submitted;

  LiveExamData({
    required this.id,
    required this.examName,
    required this.examDescription,
    required this.examSectionId,
    this.examCategoryId,
    required this.duration,
    required this.totalMarks,
    required this.cutMarks,
    required this.examDate,
    required this.submitted,
  });

  factory LiveExamData.fromJson(Map<String, dynamic> json) => LiveExamData(
        id: json['id'] ?? 0,
        examName: json['exam_name'] ?? '',
        examDescription: json['exam_description'] ?? '',
        examSectionId: json['exam_section_id'] ?? "0",
        examCategoryId: json['exam_category_id'],
        duration: json['duration'] ?? "0",
        totalMarks: json['total_marks'] ?? "0",
        cutMarks: (json['cut_marks'] ?? "0"),
        examDate: json['exam_date'] ?? '',
        submitted: json['submitted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'exam_name': examName,
        'exam_description': examDescription,
        'exam_section_id': examSectionId,
        'exam_category_id': examCategoryId,
        'duration': duration,
        'total_marks': totalMarks,
        'cut_marks': cutMarks,
        'exam_date': examDate,
        'submitted': submitted,
      };
}

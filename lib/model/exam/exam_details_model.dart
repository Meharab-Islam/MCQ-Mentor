class ExamDetailsResponse {
  final bool success;
  final ExamDetailsModel? data;

  ExamDetailsResponse({
    required this.success,
    this.data,
  });

  factory ExamDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ExamDetailsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? ExamDetailsModel.fromJson(json['data'])
          : null,
    );
  }
}

class ExamDetailsModel {
  final int id;
  final String examName;
  final String examDescription;
  final String? examSectionId;
  final String? examCategoryId;
  final String? duration;
  final String? totalMarks;
  final double? cutMarks;
  final String? examDate;
  final Map<String, List<String>> questions; // ✅ List<String>
  final List<String> pdfs;
  final List<String> videos;
  final String status;

  ExamDetailsModel({
    required this.id,
    required this.examName,
    required this.examDescription,
    this.examSectionId,
    this.examCategoryId,
    this.duration,
    this.totalMarks,
    this.cutMarks,
    this.examDate,
    required this.questions,
    required this.pdfs,
    required this.videos,
    required this.status,
  });

  factory ExamDetailsModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing for cutMarks
    double? parseCutMarks(dynamic value) {
      if (value == null) return null;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      if (value is String) return double.tryParse(value);
      return null;
    }

    return ExamDetailsModel(
      id: json['id'] ?? 0,
      examName: json['exam_name'] ?? '',
      examDescription: json['exam_description'] ?? '',
      examSectionId: json['exam_section_id'],
      examCategoryId: json['exam_category_id'],
      duration: json['duration'],
      totalMarks: json['total_marks'],
      cutMarks: parseCutMarks(json['cut_marks']),
      examDate: json['exam_date'],
      questions: (json['questions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              k,
              (v as List<dynamic>).map((e) => e.toString()).toList(),
            ),
          ) ??
          {},
      pdfs: (json['pdfs'] as List?)?.map((e) => e.toString()).toList() ?? [],
      videos:
          (json['videos'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: json['status'] ?? '',
    );
  }
}

class ArchiveExamModel {
  final int id;
  final String examName;
  final String examDescription;
  final String duration;
  final String totalMarks;
  final String cutMarks;
  final String negativeMarks;
  final String positiveMarks;
  final String examDate;
  final List<String> pdfs;
  final List<String> videos;
  final String status;

  ArchiveExamModel({
    required this.id,
    required this.examName,
    required this.examDescription,
    required this.duration,
    required this.totalMarks,
    required this.cutMarks,
    required this.negativeMarks,
    required this.positiveMarks,
    required this.examDate,
    required this.pdfs,
    required this.videos,
    required this.status,
  });

  factory ArchiveExamModel.fromJson(Map<String, dynamic> json) {
    return ArchiveExamModel(
      id: json['id'],
      examName: json['exam_name'] ?? '',
      examDescription: json['exam_description'] ?? '',
      duration: json['duration'] ?? '0',
      totalMarks: json['total_marks'] ?? '0',
      cutMarks: (json['cut_marks'] ?? '0'),
      negativeMarks: (json['negative_marks'] ?? '0'),
      positiveMarks: (json['positive_marks'] ?? '0'),
      examDate: json['exam_date'] ?? '',
      pdfs: List<String>.from(json['pdfs'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      status: json['status'] ?? '',
    );
  }
}

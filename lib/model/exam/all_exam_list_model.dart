class ExamListResponse {
  final Pagination pagination;
  final String message;
  final List<ExamData> data;

  ExamListResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory ExamListResponse.fromJson(Map<String, dynamic> json) {
    return ExamListResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => ExamData.fromJson(e))
          .toList(),
    );
  }
}

class Pagination {
  final int perPage;
  final int totalCount;
  final int totalPage;
  final int currentPage;
  final int currentPageCount;
  final int? nextPage;
  final int? previousPage;

  Pagination({
    required this.perPage,
    required this.totalCount,
    required this.totalPage,
    required this.currentPage,
    required this.currentPageCount,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      perPage: int.tryParse(json['per_page'].toString()) ?? 0,
      totalCount: int.tryParse(json['total_count'].toString()) ?? 0,
      totalPage: int.tryParse(json['total_page'].toString()) ?? 0,
      currentPage: int.tryParse(json['current_page'].toString()) ?? 0,
      currentPageCount: int.tryParse(json['current_page_count'].toString()) ?? 0,
      nextPage: json['next_page'] != null
          ? int.tryParse(json['next_page'].toString())
          : null,
      previousPage: json['previous_page'] != null
          ? int.tryParse(json['previous_page'].toString())
          : null,
    );
  }
}

class ExamData {
  final int id;
  final String examName;
  final String examDescription;
  final int duration;
  final int totalMarks;
  final double cutMarks;
  final String examDate;
  final String createdAt;

  ExamData({
    required this.id,
    required this.examName,
    required this.examDescription,
    required this.duration,
    required this.totalMarks,
    required this.cutMarks,
    required this.examDate,
    required this.createdAt,
  });

  factory ExamData.fromJson(Map<String, dynamic> json) {
    return ExamData(
      id: json['id'] ?? 0,
      examName: json['exam_name'] ?? '',
      examDescription: json['exam_description'] ?? '',
      duration: json['duration'] ?? 0,
      totalMarks: json['total_marks'] ?? 0,
      cutMarks: (json['cut_marks'] is int)
          ? (json['cut_marks'] as int).toDouble()
          : double.tryParse(json['cut_marks'].toString()) ?? 0.0,
      examDate: json['exam_date'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class AllRoutineResponse {
  final Pagination pagination;
  final String message;
  final List<AllRoutine> data;

  AllRoutineResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory AllRoutineResponse.fromJson(Map<String, dynamic> json) {
    return AllRoutineResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'] ?? "",
      data: (json['data'] as List? ?? [])
          .map((e) => AllRoutine.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  final int limitPage; // int instead of String
  final int totalCount;
  final int totalPage;
  final int currentPage;
  final int currentPageCount;
  final int? nextPage;
  final int? previousPage;

  Pagination({
    required this.limitPage,
    required this.totalCount,
    required this.totalPage,
    required this.currentPage,
    required this.currentPageCount,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limitPage: int.tryParse(json['limit_page'].toString()) ?? 0,
      totalCount: json['total_count'] ?? 0,
      totalPage: json['total_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      currentPageCount: json['current_page_count'] ?? 0,
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit_page': limitPage,
      'total_count': totalCount,
      'total_page': totalPage,
      'current_page': currentPage,
      'current_page_count': currentPageCount,
      'next_page': nextPage,
      'previous_page': previousPage,
    };
  }
}

class AllRoutine {
  final int id;
  final String name;
  final int? curriculamId;
  final int? examSectionId;
  final int? examCategoryId;
  final String totalMarks;
  final String duration;
  final String description;
  final String? file;
  final String date;
  final String status;

  AllRoutine({
    required this.id,
    required this.name,
    this.curriculamId,
    this.examSectionId,
    this.examCategoryId,
    required this.totalMarks,
    required this.duration,
    required this.description,
    required this.file,
    required this.date,
    required this.status,
  });

  factory AllRoutine.fromJson(Map<String, dynamic> json) {
    return AllRoutine(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      curriculamId: json['curriculam_id'],
      examSectionId: json['exam_section_id'],
      examCategoryId: json['exam_category_id'],
      totalMarks: json['total_marks']?.toString() ?? "0",
      duration: json['duration']?.toString() ?? "0",
      description: json['description'] ?? "",
      file: json['file'] ?? "",
      date: json['date'] ?? "",
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'curriculam_id': curriculamId,
      'exam_section_id': examSectionId,
      'exam_category_id': examCategoryId,
      'total_marks': totalMarks,
      'duration': duration,
      'description': description,
      'file': file,
      'date': date,
      'status': status,
    };
  }
}

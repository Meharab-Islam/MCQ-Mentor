class PdfFile {
  final int id;
  final int? examSectionId;
  final int? examCategoryId;
  final String name;
  final String pdfUrl;
  final String details;
  final String status;

  PdfFile({
    required this.id,
    this.examSectionId,
    this.examCategoryId,
    required this.name,
    required this.pdfUrl,
    required this.details,
    required this.status,
  });

  factory PdfFile.fromJson(Map<String, dynamic> json) {
    return PdfFile(
      id: json['id'],
      examSectionId: json['exam_section_id'] != null
          ? int.tryParse(json['exam_section_id'].toString())
          : null,
      examCategoryId: json['exam_category_id'] != null
          ? int.tryParse(json['exam_category_id'].toString())
          : null,
      name: json['name'] ?? '',
      pdfUrl: json['pdf'] ?? '',
      details: json['details'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Pagination {
  final int limitPage;
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
      nextPage: json['next_page'] != null
          ? int.tryParse(json['next_page'].toString())
          : null,
      previousPage: json['previous_page'] != null
          ? int.tryParse(json['previous_page'].toString())
          : null,
    );
  }
}

class PdfResponse {
  final Pagination pagination;
  final String message;
  final List<PdfFile> data;

  PdfResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory PdfResponse.fromJson(Map<String, dynamic> json) {
    return PdfResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => PdfFile.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class QuestionBankCategoryResponse {
  final Pagination pagination;
  final String message;
  final List<QuestionBankCategory> data;

  QuestionBankCategoryResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory QuestionBankCategoryResponse.fromJson(Map<String, dynamic> json) {
    return QuestionBankCategoryResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => QuestionBankCategory.fromJson(e))
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
      perPage: json['per_page'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      totalPage: json['total_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      currentPageCount: json['current_page_count'] ?? 0,
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class QuestionBankCategory {
  final int id;
  final String name;
  final String status;

  QuestionBankCategory({
    required this.id,
    required this.name,
    required this.status,
  });

  factory QuestionBankCategory.fromJson(Map<String, dynamic> json) {
    return QuestionBankCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

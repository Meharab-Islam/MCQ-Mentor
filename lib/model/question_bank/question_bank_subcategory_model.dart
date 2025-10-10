class QuestionBankSubCategoryResponse {
  final Pagination pagination;
  final String message;
  final List<QuestionBankSubCategory> data;

  QuestionBankSubCategoryResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory QuestionBankSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return QuestionBankSubCategoryResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => QuestionBankSubCategory.fromJson(e))
          .toList(),
    );
  }
}

class QuestionBankSubCategory {
  final int id;
  final String name;
  final String categoryId;
  final String status;

  QuestionBankSubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.status,
  });

  factory QuestionBankSubCategory.fromJson(Map<String, dynamic> json) {
    return QuestionBankSubCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['question_bank_category_id'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Pagination {
  final int perPage;
  final int totalCount;
  final int totalPage;
  final int currentPage;
  final int currentPageCount;
  final dynamic nextPage;
  final dynamic previousPage;

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
      currentPageCount:
          int.tryParse(json['current_page_count'].toString()) ?? 0,
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

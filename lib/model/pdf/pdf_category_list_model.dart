class PDFCategory {
  final int id;
  final String name;
  final String? icon;
  final String status;

  PDFCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.status,
  });

  factory PDFCategory.fromJson(Map<String, dynamic> json) {
    return PDFCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      status: json['status'],
    );
  }
}

class Pagination {
  final int limitPage;
  final int totalCount;
  final int totalPage;
  final int currentPage;
  final int currentPageCount;
  final dynamic nextPage;
  final dynamic previousPage;

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
      limitPage: int.parse(json['limit_page'].toString()),
      totalCount: json['total_count'],
      totalPage: json['total_page'],
      currentPage: json['current_page'],
      currentPageCount: json['current_page_count'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class PDFCategoryResponse {
  final Pagination pagination;
  final String message;
  final List<PDFCategory> data;

  PDFCategoryResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory PDFCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PDFCategoryResponse(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'],
      data: List<PDFCategory>.from(
        json['data'].map((item) => PDFCategory.fromJson(item)),
      ),
    );
  }
}

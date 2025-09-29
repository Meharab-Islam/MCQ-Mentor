class ExamItemListResponse {
  final Pagination pagination;
  final String message;
  final List<ExamItem> data;

  ExamItemListResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory ExamItemListResponse.fromJson(Map<String, dynamic> json) {
    return ExamItemListResponse(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ExamItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pagination": pagination.toJson(),
      "message": message,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }
}

class Pagination {
  final String limitPage;
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
      limitPage: json['limit_page']?.toString() ?? '0',
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
      "limit_page": limitPage,
      "total_count": totalCount,
      "total_page": totalPage,
      "current_page": currentPage,
      "current_page_count": currentPageCount,
      "next_page": nextPage,
      "previous_page": previousPage,
    };
  }
}

class ExamItem {
  final int id;
  final String name;
  final String icon;
  final String status;

  ExamItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
  });

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "icon": icon,
      "status": status,
    };
  }
}

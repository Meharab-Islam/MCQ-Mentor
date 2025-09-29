class ExamCategoriesResponse {
  final Pagination pagination;
  final String message;
  final List<ExamCategory> data;

  ExamCategoriesResponse({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory ExamCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return ExamCategoriesResponse(
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => ExamCategory.fromJson(e))
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

class ExamCategory {
  final int id;
  final String name;
  final String? description;
  final bool live;
  final String status;
  final int examSectionId;
  final List<ExamItem> examItemLists;

  ExamCategory({
    required this.id,
    required this.name,
    this.description,
    required this.live,
    required this.status,
    required this.examSectionId,
    required this.examItemLists,
  });

  factory ExamCategory.fromJson(Map<String, dynamic> json) {
    return ExamCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      live: json['live'] ?? false,
      status: json['status'] ?? '',
      examSectionId: json['exam_section_id'] ?? 0,
      examItemLists: (json['exam_item_lists'] as List? ?? [])
          .map((e) => ExamItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "live": live,
      "status": status,
      "exam_section_id": examSectionId,
      "exam_item_lists": examItemLists.map((e) => e.toJson()).toList(),
    };
  }
}

class ExamItem {
  final int? id;
  final String? title;

  ExamItem({
    this.id,
    this.title,
  });

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}

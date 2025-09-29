class StudySectionsModel {
  final Pagination pagination;
  final String message;
  final List<StudySectionData> data;

  StudySectionsModel({
    required this.pagination,
    required this.message,
    required this.data,
  });

  factory StudySectionsModel.fromJson(Map<String, dynamic> json) {
    return StudySectionsModel(
      pagination: Pagination.fromJson(json['pagination']),
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => StudySectionData.fromJson(item))
          .toList(),
    );
  }
}

class Pagination {
  final String limitPage;
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
    required this.nextPage,
    required this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limitPage: json['limit_page'],
      totalCount: json['total_count'],
      totalPage: json['total_page'],
      currentPage: json['current_page'],
      currentPageCount: json['current_page_count'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class StudySectionData {
  final int id;
  final String name;
  final dynamic icon;
  final String status;

  StudySectionData({
    required this.id,
    required this.name,
    required this.icon,
    required this.status,
  });

  factory StudySectionData.fromJson(Map<String, dynamic> json) {
    return StudySectionData(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      status: json['status'],
    );
  }
}
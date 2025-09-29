class ExamSectionsModel {
  final Pagination? pagination;
  final String? message;
  final List<ExamSectionData>? data;

  ExamSectionsModel({this.pagination, this.message, this.data});

  factory ExamSectionsModel.fromJson(Map<String, dynamic> json) {
    return ExamSectionsModel(
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((item) => ExamSectionData.fromJson(item))
          .toList(),
    );
  }
}

class Pagination {
  final int? limitPage;
  final int? totalCount;
  final int? totalPage;
  final int? currentPage;
  final int? currentPageCount;
  final dynamic nextPage;
  final dynamic previousPage;

  Pagination({
    this.limitPage,
    this.totalCount,
    this.totalPage,
    this.currentPage,
    this.currentPageCount,
    this.nextPage,
    this.previousPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limitPage: json['limit_page'] is int
          ? json['limit_page']
          : int.tryParse(json['limit_page'].toString()),
      totalCount: json['total_count'],
      totalPage: json['total_page'],
      currentPage: json['current_page'],
      currentPageCount: json['current_page_count'],
      nextPage: json['next_page'],
      previousPage: json['previous_page'],
    );
  }
}

class ExamSectionData {
  final int? id;
  final String? name;
  final String? description;
  final String? examDate;
  final bool? live;
  final String? icon;
  final String? status;
  final List<dynamic>? examCategories;
  final List<dynamic>? examItemLists;

  ExamSectionData({
    this.id,
    this.name,
    this.description,
    this.examDate,
    this.live,
    this.icon,
    this.status,
    this.examCategories,
    this.examItemLists,
  });

  factory ExamSectionData.fromJson(Map<String, dynamic> json) {
    return ExamSectionData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      examDate: json['exam_date'],
      live: json['live'],
      icon: json['icon'],
      status: json['status'],
      examCategories: json['exam_categories'] as List<dynamic>?,
      examItemLists: json['exam_item_lists'] as List<dynamic>?,
    );
  }
}

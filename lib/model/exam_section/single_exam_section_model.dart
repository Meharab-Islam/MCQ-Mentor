// Root model
class SingleExamDetailsResponse {
  final String message;
  final ExamSectionData data;

  final bool category;

  SingleExamDetailsResponse({
    required this.message,
    required this.data,
    required this.category

  });

  factory SingleExamDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SingleExamDetailsResponse(
      message: json['message'] ?? "",
      data: ExamSectionData.fromJson(json['data'] ?? {}),
      category: json['category']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": data.toJson(),
      "category": category,
    };
  }
}

// Exam Section main object
class ExamSectionData {
  final int id;
  final String name;
  final String? description;
  final String? examDate;
  final bool live;
  final String? icon;
  final String status;


  ExamSectionData({
    required this.id,
    required this.name,
    this.description,
    this.examDate,
    required this.live,
    this.icon,
    required this.status,

  });

  factory ExamSectionData.fromJson(Map<String, dynamic> json) {
    return ExamSectionData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'],
      examDate: json['exam_date'],
      live: json['live'] ?? false,
      icon: json['icon'],
      status: json['status'] ?? "",

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "exam_date": examDate,
      "live": live,
      "icon": icon,
      "status": status,
    };
  }
}

// Exam Category model
class ExamCategoryData {
  final int id;
  final String name;
  final bool live;
  final String status;

  ExamCategoryData({
    required this.id,
    required this.name,
    required this.live,
    required this.status,
  });

  factory ExamCategoryData.fromJson(Map<String, dynamic> json) {
    return ExamCategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      live: json['live'] ?? false,
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "live": live,
      "status": status,
    };
  }
}

// Exam Item model
class ExamItemData {
  final int id;
  final String name;
  final String? icon;
  final String status;

  ExamItemData({
    required this.id,
    required this.name,
    this.icon,
    required this.status,
  });

  factory ExamItemData.fromJson(Map<String, dynamic> json) {
    return ExamItemData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      icon: json['icon'],
      status: json['status'] ?? "",
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

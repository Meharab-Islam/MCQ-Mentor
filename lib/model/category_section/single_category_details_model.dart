class SingleCategoryDetailsModel {
  final String message;
  final ExamCategoryData data;
  final bool routine;

  SingleCategoryDetailsModel({
    required this.message,
    required this.data,
    required this.routine,
  });

  factory SingleCategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return SingleCategoryDetailsModel(
      message: json['message'] ?? '',
      data: ExamCategoryData.fromJson(json['data'] ?? {}),
      routine: json['routine'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "data": data.toJson(),
      "routine": routine,
    };
  }
}

class ExamCategoryData {
  final int id;
  final int examSectionId;
  final String name;
  final String description;
  final bool live;
  final String status;

  ExamCategoryData({
    required this.id,
    required this.examSectionId,
    required this.name,
    required this.description,
    required this.live,
    required this.status,
  });

  factory ExamCategoryData.fromJson(Map<String, dynamic> json) {
    return ExamCategoryData(
      id: json['id'] ?? 0,
      examSectionId: json['exam_section_id'] ?? 0,
      name: json['name']??"",
      description: json['description'] ?? '',
      live: json['live'] ?? false,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "exam_section_id": examSectionId,
      "description": description,
      "live": live,
      "status": status,
    };
  }
}

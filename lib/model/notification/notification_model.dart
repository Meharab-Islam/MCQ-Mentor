class NotificationModel {
  final int id;
  final String title;
  final String description;
  final bool isRead; // frontend only

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false, // default false
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      isRead: false, // always false when fetched from API
    );
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isRead: isRead ?? this.isRead,
    );
  }
}

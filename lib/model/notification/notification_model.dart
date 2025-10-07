class NotificationModel {
  final int id;
  final String title;
  final String description;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

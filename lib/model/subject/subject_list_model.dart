class SubjectListModel {
  final int id;
  final String name;
  final String? icon;
  final String status;

  SubjectListModel({
    required this.id,
    required this.name,
    this.icon,
    required this.status,
  });

  factory SubjectListModel.fromJson(Map<String, dynamic> json) {
    return SubjectListModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'],
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'status': status,
      };
}

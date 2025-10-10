class AllCategoryListForPdf {
  final int id;
  final String name;

  AllCategoryListForPdf({
    required this.id,
    required this.name,
  });

  factory AllCategoryListForPdf.fromJson(Map<String, dynamic> json) {
    return AllCategoryListForPdf(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

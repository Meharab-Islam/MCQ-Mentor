// package_model.dart
class PackageFeature {
  final int id;
  final int packageId;
  final String name;
  final String status;

  PackageFeature({
    required this.id,
    required this.packageId,
    required this.name,
    required this.status,
  });

  factory PackageFeature.fromJson(Map<String, dynamic> json) {
    return PackageFeature(
      id: json['id'],
      packageId: json['package_id'],
      name: json['name'],
      status: json['status'],
    );
  }
}

class PackageListModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String status;
  final List<PackageFeature> packageFeatures;

  PackageListModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.status,
    required this.packageFeatures,
  });

  factory PackageListModel.fromJson(Map<String, dynamic> json) {
    return PackageListModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      duration: json['duration'],
      status: json['status'],
      packageFeatures: (json['package_features'] as List)
          .map((f) => PackageFeature.fromJson(f))
          .toList(),
    );
  }
}

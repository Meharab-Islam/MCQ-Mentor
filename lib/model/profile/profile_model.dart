class StudentProfile {
  final int id;
  final String name;
  final String email;
  final String? gender;
  final int? age;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? image;
  final bool hasPackage;
  final List<PackageModel> packages;

  StudentProfile({
    required this.id,
    required this.name,
    required this.email,
    this.gender,
    this.age,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.image,
    required this.hasPackage,
    required this.packages,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    return StudentProfile(
      id: profile['id'] ?? 0,
      name: profile['name'] ?? '',
      email: profile['email'] ?? '',
      gender: profile['gender'],
      age: profile['age'],
      phone: profile['phone'],
      address: profile['address'],
      dateOfBirth: profile['date_of_birth'] != null
          ? DateTime.tryParse(profile['date_of_birth'])
          : null,
      image: profile['image'],
      hasPackage: json['hasPackage'] ?? false,
      packages: (json['packages'] as List<dynamic>? ?? [])
          .map((e) => PackageModel.fromJson(e))
          .toList(),
    );
  }
}

class PackageModel {
  final int id;
  final String tranId;
  final String userId;
  final String packageId;
  final String amount;
  final String paidBy;
  final String paymentStatus;
  final String paymentDate;
  final PackageDetails package;

  PackageModel({
    required this.id,
    required this.tranId,
    required this.userId,
    required this.packageId,
    required this.amount,
    required this.paidBy,
    required this.paymentStatus,
    required this.paymentDate,
    required this.package,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] ?? 0,
      tranId: json['tran_id'] ?? '',
      userId: json['user_id'] ?? '',
      packageId: json['package_id'] ?? '',
      amount: json['amount'] ?? '',
      paidBy: json['paid_by'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentDate: json['payment_date'] ?? '',
      package: PackageDetails.fromJson(json['package'] ?? {}),
    );
  }
}

class PackageDetails {
  final int id;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String status;
  final List<PackageFeature> features;

  PackageDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.status,
    required this.features,
  });

  factory PackageDetails.fromJson(Map<String, dynamic> json) {
    return PackageDetails(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? '',
      status: json['status'] ?? '',
      features: (json['package_features'] as List<dynamic>? ?? [])
          .map((e) => PackageFeature.fromJson(e))
          .toList(),
    );
  }
}

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
      id: json['id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

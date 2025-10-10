class EditProfileModel {
  String name;
  String address;
  String dateOfBirth;
  String phone;
  String gender;
  String image;

  EditProfileModel({
    required this.name,
    required this.address,
    required this.dateOfBirth,
    required this.phone,
    required this.gender,
    required this.image,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? 'male',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'date_of_birth': dateOfBirth,
      'phone': phone,
      'gender': gender,
      'image': image,
    };
  }
}

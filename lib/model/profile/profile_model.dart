// models/student_profile.dart
class StudentProfile {
  final String name;
  final String email;
  final String gender;
  final int age;
  final String phone;
  final String address;
  final DateTime dateOfBirth;
  final String image;

  StudentProfile({
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.phone,
    required this.address,
    required this.dateOfBirth,
    required this.image,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth'] ?? DateTime.now().toString()),
      image: json['image'] ?? '',
    );
  }
}

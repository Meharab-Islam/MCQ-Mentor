class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  /// A factory constructor to create a [User] instance from a JSON map.
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// A method to convert a [User] instance into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

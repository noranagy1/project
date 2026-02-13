class UserModel{
  final String name;
  final String email;
  final String password;
  final String? role;
  final String? token;
  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.role,
    this.token,
});
  factory UserModel.fromJson(Map<String, dynamic> json) { /// هعدلها مع رؤي
    return UserModel(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      role: json['role'] ?? "",
      token: json['token'] ?? "",
    );
  }
}

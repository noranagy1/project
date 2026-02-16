class UserModel{
  final String name;
  final String email;
  final String password;
  final String? role; /// اختياري ممكن تكون null
  final String? token; /// اختياري ممكن تكون null
  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.role,
    this.token,
});
  /// Factory Constructor مش constructor عادي
  /// وظيفته: إنه يبني كائن (Object) من حاجة موجودة بالفعل هنا، الحاجة الموجودة = JSON من السيرفر
  factory UserModel.fromJson(Map<String, dynamic> json) { /// هعدلها مع رؤي باللى هي كتباه
    return UserModel(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      password: json['password'],
      role: json['role'] , /// ممكن يكونوا مش موجودين من السيرفر، ومن الأفضل نخليهم nullable بدل ما نخزن "" وهم فعليًا مش موجودين
      token: json['token'],
    );
  }
}
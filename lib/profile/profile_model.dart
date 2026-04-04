class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String employeeNumber;
  final String qrCode;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.employeeNumber,
    required this.qrCode,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      employeeNumber: json['employeeNumber'] ?? '',
      qrCode: json['qr_code']?.toString() ?? '',
    );
  }
}
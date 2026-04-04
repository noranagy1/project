class UserEntity {
  final String name;
  final String email;
  final String password;
  final String role;
  final String qrCode;
  final String qrExpires;
  final String employeeNumber;
  final String id;


  UserEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.qrCode,
    required this.qrExpires,
    required this.employeeNumber,
    required this.id,
  });
}
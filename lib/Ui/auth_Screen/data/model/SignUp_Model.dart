import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';
import 'package:new_project/Ui/auth_Screen/domain/enites/user_entity.dart';

class SignUpModel {
  SignUpModel({
      this.message, 
      this.token, 
      this.employee,

  });

  SignUpModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    employee = json['employee'] != null ? Employee.fromJson(json['employee']) : null;
  }
  String? message;
  String? token;
  Employee? employee;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (employee != null) {
      map['employee'] = employee?.toJson();
    }
    return map;
  }
  AuthResult toEntity() {
    return AuthResult(
      message: message??"",
      token: token??"",
      user: employee!.toEntity(),

    );
  }

}

class Employee {
  Employee({
      this.name, 
      this.email, 
      this.role, 
      this.isBanned, 
      this.qrCode, 
      this.qrExpires, 
      this.id, 
      this.tokens, 
      this.employeeNumber, 
      this.createdAt, 
      this.updatedAt, 
      this.v,});

  Employee.fromJson(dynamic json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
    isBanned = json['isBanned'];
    qrCode = json['qr_code'];
    qrExpires = json['qr_expires'];
    id = json['_id'];
    if (json['tokens'] != null) {
      tokens = [];
      json['tokens'].forEach((v) {
        tokens?.add(Tokens.fromJson(v));
      });
    }
    employeeNumber = json['employeeNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
  String? name;
  String? email;
  String? role;
  bool? isBanned;
  dynamic qrCode;
  dynamic qrExpires;
  String? id;
  List<Tokens>? tokens;
  String? employeeNumber;
  String? createdAt;
  String? updatedAt;
  int? v;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['email'] = email;
    map['role'] = role;
    map['isBanned'] = isBanned;
    map['qr_code'] = qrCode;
    map['qr_expires'] = qrExpires;
    map['_id'] = id;
    if (tokens != null) {
      map['tokens'] = tokens?.map((v) => v.toJson()).toList();
    }
    map['employeeNumber'] = employeeNumber;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
  UserEntity toEntity() {
    return UserEntity(
      name: name ?? '',
      email: email ?? '',
      password: '',
      role: role ?? '',
      qrCode: qrCode?.toString() ?? '',
      qrExpires: qrExpires?.toString() ?? '',
      employeeNumber: employeeNumber ?? '', id: '',

    );
  }

}

class Tokens {
  Tokens({
      this.token, 
      this.id,});

  Tokens.fromJson(dynamic json) {
    token = json['token'];
    id = json['_id'];
  }
  String? token;
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['_id'] = id;
    return map;
  }

}
import 'package:new_project/Ui/auth_Screen/domain/enites/user_entity.dart';

class AuthResult {
  final String message;
  final String token;
  final UserEntity user ;

  AuthResult({required this.message,required this.token,required this.user,});


}
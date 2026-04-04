import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';

abstract class LoginState {}

class LoginInitialState extends LoginState {}
class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;
  LoginErrorState({required this.message});
}

class LoginSuccessState extends LoginState {
  final AuthResult authResult;
  LoginSuccessState({required this.authResult});
}
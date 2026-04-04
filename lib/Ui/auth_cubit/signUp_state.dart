import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';

abstract class SignupState {}

class LoadingState extends SignupState {}
class InitialState extends SignupState {}

class ErrorState extends SignupState {
  final String message;
  ErrorState({required this.message});
}

class SuccessState extends SignupState {
  final AuthResult authResult;
  SuccessState({required this.authResult});
}

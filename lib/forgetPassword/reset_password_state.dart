abstract class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}
class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  final String message;
  ResetPasswordSuccessState({required this.message});
}

class ResetPasswordErrorState extends ResetPasswordState {
  final String message;
  ResetPasswordErrorState({required this.message});
}
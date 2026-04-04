abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}
class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final String message;
  ForgotPasswordSuccessState({required this.message});
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String message;
  ForgotPasswordErrorState({required this.message});
}
abstract class CheckInState {}

class CheckInInitialState extends CheckInState {}
class CheckInLoadingState extends CheckInState {}

class CheckInSuccessState extends CheckInState {
  final String message;
  CheckInSuccessState({required this.message});
}

class CheckInErrorState extends CheckInState {
  final String message;
  CheckInErrorState({required this.message});
}
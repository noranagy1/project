import 'profile_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileUpdateLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final ProfileModel model;
  ProfileSuccessState({required this.model});
}

class ProfileUpdateSuccessState extends ProfileState {
  final ProfileModel model;
  ProfileUpdateSuccessState({required this.model});
}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState({required this.message});
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'profile_repository.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  ProfileCubit(this._repository) : super(ProfileInitialState());

  Future<void> getProfile() async {
    emit(ProfileLoadingState());
    final result = await _repository.getProfile();
    result.fold(
          (failure) => emit(ProfileErrorState(message: failure.message)),
          (model) => emit(ProfileSuccessState(model: model)),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    emit(ProfileUpdateLoadingState());
    final result = await _repository.updateProfile(name: name, email: email);
    result.fold(
          (failure) => emit(ProfileErrorState(message: failure.message)),
          (model) {

        UserSession.name = model.name;
        UserSession.email = model.email;
        UserSession.save();
        emit(ProfileUpdateSuccessState(model: model));
      },
    );
  }
}
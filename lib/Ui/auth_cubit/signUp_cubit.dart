import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/Ui/auth_Screen/domain/auth_repository/auth-repository.dart';
import 'package:new_project/Ui/auth_cubit/signUp_state.dart';


@injectable

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit(this._authRepository) : super(InitialState());
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,

  }) async {
    emit(LoadingState());
    final result = await _authRepository.signUp(
      name: name,
      email: email,
      password: password,
      role: role,

    );
    result.fold(
      (failure) => emit(ErrorState(message: failure.message)),
      (authResult) => emit(SuccessState(authResult: authResult)),
    );
  }
}

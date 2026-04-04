import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'login_repository.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _loginRepository;
  LoginCubit(this._loginRepository) : super(LoginInitialState());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    final result = await _loginRepository.login(
      email: email,
      password: password,
    );
    result.fold(
          (failure) => emit(LoginErrorState(message: failure.message)),
          (authResult) => emit(LoginSuccessState(authResult: authResult)),
    );
  }
}
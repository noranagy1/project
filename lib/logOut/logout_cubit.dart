// logout_cubit.dart
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';

abstract class LogoutState {}
class LogoutInitial extends LogoutState {}
class LogoutLoading extends LogoutState {}
class LogoutSuccess extends LogoutState {}
class LogoutError extends LogoutState {
  final String message;
  LogoutError({required this.message});
}

@injectable
class LogoutCubit extends Cubit<LogoutState> {
  final Dio _dio;
  LogoutCubit(this._dio) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await _dio.post(
        AppConst.logoutEndPoint,
        options: Options(
          headers: {'Authorization': 'Bearer ${UserSession.token}'},
        ),
      );
    } catch (e) {
      if (e is DioError) {
        emit(LogoutError(message: e.response?.data['message'] ?? 'Something went wrong'));
      } else {
        emit(LogoutError(message: e.toString()));
      }
      return;
    }

    await UserSession.clear();
    emit(LogoutSuccess());
  }
}
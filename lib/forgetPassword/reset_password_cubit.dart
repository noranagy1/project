import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final Dio _dio;
  ResetPasswordCubit(this._dio) : super(ResetPasswordInitialState());

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoadingState());
    try {
      final response = await _dio.post(
        AppConst.resetPasswordEndPoint,
        data: {'newPassword': newPassword},
        options: Options(
          headers: {'Authorization': 'Bearer $token'}, // ✅ JWT في الـ header
        ),
      );
      emit(ResetPasswordSuccessState(
        message: response.data['message'] ?? 'Password reset successfully',
      ));
    } on DioException catch (e) {
      emit(ResetPasswordErrorState(
        message: e.response?.data['message'] ?? 'Something went wrong',
      ));
    } catch (e) {
      emit(ResetPasswordErrorState(message: e.toString()));
    }
  }
}
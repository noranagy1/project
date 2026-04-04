import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final Dio _dio;
  ForgotPasswordCubit(this._dio) : super(ForgotPasswordInitialState());

  Future<void> forgotPassword({required String email}) async {
    emit(ForgotPasswordLoadingState());
    try {
      final response = await _dio.post(
        AppConst.forgotPasswordEndPoint,
        data: {'email': email},
      );
      emit(ForgotPasswordSuccessState(
        message: response.data['message'] ?? 'OTP sent successfully',
      ));
    } on DioException catch (e) {
      emit(ForgotPasswordErrorState(
        message: e.response?.data['message'] ?? 'Something went wrong',
      ));
    } catch (e) {
      emit(ForgotPasswordErrorState(message: e.toString()));
    }
  }
}
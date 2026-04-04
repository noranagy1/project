import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'check_in_state.dart';

@injectable
class CheckInCubit extends Cubit<CheckInState> {
  final Dio _dio;
  CheckInCubit(this._dio) : super(CheckInInitialState());

  Future<void> checkIn(String qrCode) async {
    emit(CheckInLoadingState());
    try {
      final response = await _dio.post(
        AppConst.qrCheckInEndPoint,
        data: {'qr_code': qrCode},
        options: Options(
          headers: {'Authorization': 'Bearer ${UserSession.token}'},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CheckInSuccessState(
          message: response.data['message'] ?? 'تم تسجيل الحضور ',
        ));
      } else {
        emit(CheckInErrorState(message: 'فشل تسجيل الحضور'));
      }
    } on DioException catch (e) {
      emit(CheckInErrorState(
        message: e.response?.data['message'] ?? 'حصل خطأ',
      ));
    } catch (e) {
      emit(CheckInErrorState(message: e.toString()));
    }
  }
}
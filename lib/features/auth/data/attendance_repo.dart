import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/api_service.dart';
import 'package:attendo/features/auth/data/attendance_model.dart';
import 'package:dio/dio.dart';
class AttendanceRepo {
  ApiService apiService = ApiService();
  Future<AttendanceModel?> getAttendance() async {
    try {
      final response = await apiService.get('/api/attendance/report');
      if (response is Map<String, dynamic>) {
        return AttendanceModel.fromJson(response);
      } else {
        throw ApiError(message: 'Unexpected Error');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
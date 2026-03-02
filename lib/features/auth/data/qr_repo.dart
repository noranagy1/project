import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/api_service.dart';
import 'package:dio/dio.dart';
class QrRepo {
  ApiService apiService = ApiService();

  Future<String?> getQrData() async {
    try {
      final response = await apiService.get('/api/employee/qr'); // غيري الـ endpoint على حسب الـ backend

      if (response is Map<String, dynamic>) {
        return response['qrData']?.toString(); // غيري الـ key على حسب رد السيرفر
      } else {
        throw ApiError(message: 'Unexpected response');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
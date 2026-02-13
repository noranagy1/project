import 'package:attendo/core/network/api_error.dart';
import 'package:dio/dio.dart';
class ApiExceptions{
  static ApiError handleError(DioException error){
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    if(statusCode != null) {
      if (data is Map<String, dynamic> && data ['message'] != null) {
        return ApiError(message: data['message'], statusCode: statusCode);
      }
    }
    if(statusCode == 302) {
      throw ApiError(message: 'This email is already registered');
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'Connection timeout. please check your internet connection');
        case DioExceptionType.sendTimeout:
        return ApiError(message: 'Request timeout. please try again');
        case DioExceptionType.receiveTimeout:
        return ApiError(message: 'Response timeout. please try again');
      default:
        return ApiError(message: 'An unexpected error occurred. please try again');
    }
  }
}
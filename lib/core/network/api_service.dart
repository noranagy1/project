import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/dio_client.dart';
import 'package:dio/dio.dart';
class ApiService{
  final DioClient _dioClient = DioClient();
/// get
Future <dynamic> get(String endpoint) async {
  try {
    final response = await _dioClient.dio.get(endpoint);
    return response.data;
} on DioException catch (e) {
    return ApiExceptions.handleError(e);
  }
}
  /// post
  Future <dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.post(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
  /// put // update
  Future <dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
  /// delete
  Future <dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.delete(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
}
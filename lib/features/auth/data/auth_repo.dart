import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/api_service.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';
class AuthRepo{
  ApiService apiService = ApiService();
  /// Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post(
          '/login', {'email': email, 'password': password}); /// هتأكد منهم من رؤي
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response ['code'];
        final data = response['data'];
        if (code != 200 || code != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        return user;
      }else{
        throw ApiError(message: 'UnExpected Error from server');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch(e){
      throw ApiError(message: e.toString());
    }
  }
  /// register
  Future<UserModel?> register(String name, String email, String password) async {
    try {
      final response = await apiService.post( '/register', {'name': name, 'email': email, 'password': password}); /// هتأكد منهم من رؤي
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response ['code'];
        final coder = int.parse(code);
        final data = response['data'];
        if (coder != 200 || coder != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        return user;
      }else{
        throw ApiError(message: 'UnExpected Error from server');
      }
  } on DioException catch (e) {
    throw ApiExceptions.handleError(e);
  } catch(e){
    throw ApiError(message: e.toString());
  }
  }
  /// log out
  Future<void> logout() async {
  final response = await apiService.post('/logout', {});
  if (response['data'] != null){
    throw ApiError(message: 'UnExpected Error from server. Please try again later');
  }
  await PrefHelper.clearToken();
  }
}
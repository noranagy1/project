import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/api_service.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:dio/dio.dart';
class AuthRepo {
  ApiService apiService = ApiService();
  /// Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService
          .post('/api/auth/login', {'email': email, 'password': password});
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message']?.toString();
        final code = response['code'];
        final coder =
        code is int ? code : int.tryParse(code?.toString() ?? '0') ?? 0;
        final data = response['employee'];
        final token = response['token']?.toString(); // ✅ تحويل لـ String

        if (data == null) {
          throw ApiError(message: "No user data returned");
        }

        // ✅ حفظ الـ token مباشرة من الـ response مش من الـ user
        if (token != null && token.isNotEmpty) {
          await PrefHelper.saveToken(token);
        }

        final employeeData =
        data is Map<String, dynamic> ? Map<String, dynamic>.from(data) : <String, dynamic>{};
        employeeData['token'] = token;
        employeeData['password'] = password;

        final user = UserModel.fromJson(employeeData);
        return user;
      } else {
        throw ApiError(message: 'Unexpected Error from server');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// register
  Future<UserModel?> register(
      String name, String email, String password, String role) async {
    try {
      final response = await apiService.post('/api/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message']?.toString();
        final code = response['code'];
        final coder =
            code is int ? code : int.tryParse(code?.toString() ?? '0') ?? 0;
        if (coder != 200 && coder != 201) {
          throw ApiError(message: msg?.toString() ?? "Unknown Error");
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        return user;
      } else {
        throw ApiError(message: 'Unexpected Error from server');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// log out
  Future<void> logout() async {
    String? token = await PrefHelper.getToken();
    if (token == null) throw ApiError(message: "No token found");
    try {
      await apiService.post(
        '/api/auth/logout',
        {},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      // مش محتاجين نشيك على الـ code، لو السيرفر رد بـ 200 يبقى نجح
      await PrefHelper.clearToken();
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }}
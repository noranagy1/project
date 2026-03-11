import 'package:attendo/core/network/api_error.dart';
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/api_service.dart';
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:attendo/features/auth/data/user_model.dart';
import 'package:attendo/ui/attendence/widget/attendance_model.dart';
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
        final token = response['token']?.toString();
        if (data == null) {
          throw ApiError(message: "No user data returned");
        }
        if (token != null && token.isNotEmpty) {
          await PrefHelper.saveToken(token);
        }
        final employeeData =
        data is Map<String, dynamic> ? Map<String, dynamic>.from(data) : <
            String,
            dynamic>{};
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
  Future<UserModel?> register(String name, String email, String password, String role) async {
    try {
      final response = await apiService.post('/api/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      });
      if (response is ApiError) throw response;
      if (response is Map<String, dynamic>) {
        final token = response['token']?.toString();
        final employeeData = response['employee'] as Map<String, dynamic>?;
        if (employeeData == null) {
          throw ApiError(message: 'Unexpected Error from server');
        }
        employeeData['token'] = token;
        final user = UserModel.fromJson(employeeData);
        if (token != null) {
          await PrefHelper.saveToken(token);
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
  }  /// log out
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
      await PrefHelper.clearToken();
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// Get Profile
  Future<UserModel?> getProfile() async {
    try {
      final response = await apiService.get('/api/employee/profile');
      if (response is Map<String, dynamic>) {
        return UserModel.fromJson(response); // شيلنا ['employee']
      } else {
        throw ApiError(message: 'Unexpected Error');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// Update Profile
  Future<void> updateProfile(String name, String email,
      String cardNumber) async {
    try {
      await apiService.put('/api/employee/update-profile', {
        'name': name,
        'email': email,
        'cardNumber': cardNumber,
      });
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  ///QR
  Future<String?> getQrData() async {
    try {
      final response = await apiService.get('/api/qr/my-qr'); // غيري الـ endpoint على حسب الـ backend
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
  /// Attendance
  Future<MonthlyReport> getMonthlyReport() async {
    try {
      final response = await apiService.get('/api/attendance/report');
      if (response is Map<String, dynamic>) {
        return MonthlyReport.fromJson(response);
      } else {
        throw ApiError(message: 'Unexpected response format');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  // ─────────────────────────────────────────
  //  FORGOT PASSWORD FLOW  (3 steps)
  // ─────────────────────────────────────────
  /// Step 1 — بيبعت إيميل للمستخدم فيه OTP
  /// بنبعت الإيميل بس، السيرفر هو اللي بيبعت الكود
  Future<void> forgotPassword(String email) async {
    try {
      final response = await apiService.post(
        '/api/auth/forgot-password',
        {'email': email},
      );
      // لو السيرفر رجّع error message هنرميه
      if (response is Map<String, dynamic>) {
        final msg = response['message']?.toString();
        final success = response['success'];
        // بعض السيرفرات بترجع success: false لو الإيميل مش موجود
        if (success == false) {
          throw ApiError(message: msg ?? 'Email not found');
        }
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// Step 2 — بيتحقق من الـ OTP اللي المستخدم كتبه
  /// بيرجع resetToken — ده token مؤقت بنستخدمه في الـ Step 3 بس
  Future<String> verifyOtp(String email, String code) async {
    try {
      final response = await apiService.post(
        '/api/auth/verify-otp',
        {'email': email, 'otp': code},
      );
      if (response is Map<String, dynamic>) {
        final resetToken = response['resetToken']?.toString()
            ?? response['token']?.toString()
            ?? ''; // ✅ لو مفيش token نرجع string فاضي
        return resetToken; // ✅ نرجع حتى لو فاضي
      }
      throw ApiError(message: 'Unexpected response from server');
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  /// Step 3 — بيعمل reset للباسورد بالـ resetToken اللي جاء من Step 2
  /// [resetToken] — التوكن المؤقت اللي رجع من verifyOtp
  /// [newPassword] — الباسورد الجديد
  /// [confirmPassword] — تأكيد الباسورد (validation على السيرفر كمان)
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await apiService.post(
        '/api/auth/change-password',
        {
          'resetToken': resetToken,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  // ── Toggle Gate ───────────────────────
  Future<void> toggleGate(String command) async {
    try {
      await apiService.post(
        '/api/device/command',
        {'command': command}, // 'open_gate' أو 'close_gate'
      );
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  Future<Map<String, dynamic>> getGateStatus() async {
    return await apiService.get('/api/gate/status');
  }
  Future<dynamic> getVehicleReport() async {
    return await apiService.get('/api/vehicles/report');
  }
}
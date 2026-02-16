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
          '/api/auth/login', {'email': email, 'password': password});/// هتأكد منهم من رؤي هي كتباهم ازاى
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'] ?.toString();
        final code = response ['code'];
        final Coder = code is int ? code : int.tryParse(code?.toString() ?? '0') ?? 0; /// لو الكود أصلاً رقم، خد الرقم مباشرة ولو الكود نص او null وحوله لنص
        /// لو هو مش نص ولو null خلى القيمه 0 وحاول نحوله لرقم لو فشل خليه 0
        final data = response['data'];
        if(data == null) {
          throw ApiError(message: "No user data returned"); /// لو السيرفر رجع null للـ data → يرمي خطأ
        }
        if (Coder != 200 && Coder != 201) { /// لو حصل error رجعي or تاني
          throw ApiError(message: msg ?? "Unknown Error"); /// ؟؟ بيحمي من null
        }
        final user = UserModel.fromJson(response['data']); /// هشوف رؤي عملاها ازاى
        /// عشان هو باعت البيانات فى data
        if (user.token != null && user.token!.isNotEmpty) { /// لو user.token جه يعنى لا يساوي null
          await PrefHelper.saveToken(user.token!); /// احفظ بقى token دا
          /// لو السيرفر رجع token موجود ومش فاضى → البرنامج يخزنه عشان نقدر نستخدمه بعد كده في أي request
        }
        return user;/// عشان اقدر استخدم البيانات بتاعته فى اي حته
      }
      else{
        throw ApiError(message: 'UnExpected Error from server');
      }
    } on DioException catch (e) { /// لو جالك error من dio اعمل catch
      throw ApiExceptions.handleError(e); /// لو جالك error فى auth_repo ارميه فى login عشان اظهره للمستخدم
    } catch(e)
    {
      throw ApiError(message: e.toString()); /// هستخدم هنا api_error عشان يظهر المسدج
    }
  }
  /// register
  Future<UserModel?> register(String name, String email, String password, String role) async {
    try {
      final response = await apiService.post( '/api/auth/signup', {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }); /// هتأكد منهم من رؤي
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        final msg = response['message'] ?.toString(); /// يحول أي قيمة ممكن تكون مش نص إلى نص → يحمي من null أو أرقام
        final code = response ['code'];
        final coder = code is int ? code : int.tryParse(code?.toString() ?? '0') ?? 0;
        if (coder != 200 && coder != 201) { /// لو حصل error رجعي or تاني
          throw ApiError(message: msg?.toString() ?? "Unknown Error");
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
  final response = await apiService.post('/api/auth/logout', {});
  if(response is ApiError) {
    throw response;
  }
  if(response is! Map<String, dynamic>) { /// بنتأكد إن الـ response رجع JSON على شكل Map لان ممكن االسيرفر يرجع نوع list او نص ودا غلط
    throw ApiError(message: "Unexpected response format");
  }
  final data = response['data']; /// بنجيب محتوى الـ data من الـ JSON اللي رجع من السيرفر
  if (data == null){
    throw ApiError(message: 'UnExpected Error from server. Please try again later');
  }
  await PrefHelper.clearToken(); /// لما المستخدم يسجل خروج، ما يفضلش أي بيانات تسجيل دخول محفوظة → عشان الأمان
  }
}
import 'package:attendo/core/network/api_exceptions.dart';
import 'package:attendo/core/network/dio_client.dart';
import 'package:dio/dio.dart';
/// اكنها reusable widget اقدر استخدمها كذا مرة
class ApiService{
  final DioClient _dioClient = DioClient();
  /// CRUD Methods
  /// get
Future <dynamic> get(String endpoint) async {
  try { /// جربي تبعتي Request لو حصل Error امسكيه
    final response = await _dioClient.dio.get(endpoint);
    return response.data;
} on DioException catch (e) {
    throw ApiExceptions.handleError(e); /// بدل ما نرجع قيمة عادية → هنتوقف فورًا
    /// الـ AuthRepo اللي مستدعي الدالة هيشوف الـ Error في الـ try-catch بتاعه
    /// يقدر يعرض رسالة للمستخدم أو يتعامل مع الخطأ بطريقة صحيحة
    /// كنا عاملينها return فى الحالة دي ممكن يرجع قيمة كأنها نتيجة طبيعية ولكن فى خطأ فى السيرفر اصلا
  }
}
  /// post
  Future <dynamic> post(String endpoint, Map<String, dynamic> body, {Options? options}) async {
    try {
      final response = await _dioClient.dio.post(endpoint, data: body , options: options);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
  /// put /// update
  Future <dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
  /// delete
  Future <dynamic> delete(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.delete(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
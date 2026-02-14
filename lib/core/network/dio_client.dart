import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:dio/dio.dart';
class DioClient{
  final Dio _dio = Dio(
    /// دا constructor بتاع dio
    /// دا بيتنفذ اول ما اعمل object من class
    /// _ دي معناها انه private يعنى بيتسخدم جوه class دي بس
    BaseOptions(
      baseUrl: 'https://sonic-zdi0.onrender.com/api',
      headers: {
        'Content-Type': 'application/json',
      }
    )
  );
  DioClient(){
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          if(token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); /// إرسال الريكوست بعد التعديل الي السيرفر
        },
      )
    );
}
Dio get dio => _dio;
}
import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:dio/dio.dart';
class DioClient{
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'Content-Type': 'application/json',
      }
    )
  );
  DioClient(){
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          if(token!.isNotEmpty && token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      )
    );
}
Dio get dio => _dio;
}
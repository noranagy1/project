import 'package:attendo/core/utils/pref_helpers.dart';
import 'package:dio/dio.dart';
class DioClient{
  final Dio _dio = Dio(
    /// دا constructor بتاع dio
    /// دا بيتنفذ اول ما اعمل object من class
    /// _ دي معناها انه private يعنى بيتسخدم جوه class دي بس
    BaseOptions(
      baseUrl: 'http://192.168.224.35:3000',
      headers: {
        'Content-Type': 'application/json',
        'Language': 'en'
      }
    )
  );
  DioClient(){
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();
          if(token != null && token.isNotEmpty) { /// الأول بنتأكد من وجود token ثم نشوف هل فيه قيمة ولا لأ
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options); /// إرسال الريكوست بعد التعديل الي السيرفر
        },
          onResponse: (response, handler) { /// اعمل اللي جوه لما السيرفر يرد على الـ request
          /// response → البيانات اللي رجعت من السيرفر (زي JSON أو أي حاجة)
          /// handler → طريقة نتحكم في الاستمرار أو التعديل قبل ما البيانات توصل لباقي التطبيق
            print("Response [${response.statusCode}] => ${response.data}");
            return handler.next(response); /// بعد ما نطبع الرد → نسمح لـ Dio يكمل إرسال البيانات لباقي التطبيق
          },
          onError: (DioException error, handler) { /// اعمل اللي جوه لما يحصل خطأ أثناء إرسال الـ request للسيرفر أو أثناء الرد
            print("Error [${error.response?.statusCode}] => ${error.message}");
            return handler.next(error);
          },
      )
    );
}
Dio get dio => _dio;
}
import 'package:attendo/core/network/api_error.dart';
import 'package:dio/dio.dart';
/// مسؤول عن الاخطاء اللى بتيجى من السيرفر انا مليش دعوة بيها بحاول بس اني اهندلها
class ApiExceptions{
  static ApiError handleError(DioException error){
    final statusCode = error.response?.statusCode; /// بيحاول يجيب رقم الخطأ اللي رجع من السيرفر ويحطه في متغير اسمه statusCode وعملنا response انه ممكن يرجع رقم وممكن لا
    final data = error.response?.data; /// بيجيب البيانات اللي رجعت من السيرفر لما حصل Error
    if(statusCode != null) {
      if (data is Map<String, dynamic> && data ['message'] != null) {
        return ApiError(message: data['message']?.toString() ?? 'Unknown error occurred', /// يضمن أن الرسالة اللي هتظهر للمستخدم دايمًا موجودة وبصيغة نصية، حتى لو السيرفر ما رجعش رسالة
            statusCode: statusCode);
      }
    }
    // print(statusCode);
    // print(data);
    if(statusCode == 302) {
      throw ApiError(message: 'This email is already registered');
    }
    switch (error.type) { /// هنا عادي ازود الحالات براحتي على حسب الايرور اللى هيطلعلى
      case DioExceptionType.connectionTimeout:
        return ApiError(message: 'Connection timeout. please check your internet connection');
        case DioExceptionType.sendTimeout:
        return ApiError(message: 'Request timeout. please try again');
        case DioExceptionType.receiveTimeout:
        return ApiError(message: 'Response timeout. please try again');
        case DioExceptionType.badResponse:
        return ApiError(message: error.toString()); /// لو في Error غير متوقع من السيرفر، نقدر نعرض التفاصيل بدل ما البرنامج يقفل فجأة
        /// حولي الخطأ كله لنص عشان يتعرض
      default:
        return ApiError(message: 'An unexpected error occurred. please try again');
    }
  }
}
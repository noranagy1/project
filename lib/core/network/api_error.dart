class ApiError{
  String message;
  int? statusCode;
  ApiError({
    required this.message,
    this.statusCode,
  });
@override
String toString(){
    return message;
  }
}
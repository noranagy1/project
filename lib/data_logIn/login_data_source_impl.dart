import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/data_logIn/login_model.dart';
import 'login_data_source.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  final Dio dio;
  LoginDataSourceImpl(this.dio);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      AppConst.loginEndPoint,
      data: {
        "email": email,
        "password": password,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginModel.fromJson(response.data);
    } else {
      throw Exception("Login failed");
    }
  }
}
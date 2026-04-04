
import 'package:new_project/data_logIn/login_model.dart';

abstract class LoginDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
  });
}
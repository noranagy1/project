

import 'package:new_project/Ui/auth_Screen/data/model/SignUp_Model.dart';

abstract class AuthDataSource {
Future<SignUpModel>signUp({
  required String name,
  required String email,
  required String password,
  required String role,

});
}
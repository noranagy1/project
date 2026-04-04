import 'package:dartz/dartz.dart';
import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';
import 'package:new_project/core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,

  });
}

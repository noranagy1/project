import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/Ui/auth_Screen/domain/enites/auth_result.dart';
import 'package:new_project/core/errors/failure.dart';
import 'login_data_source.dart';
import 'login_repository.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource _loginDataSource;
  LoginRepositoryImpl(this._loginDataSource);

  @override
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _loginDataSource.login(
        email: email,
        password: password,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Something went wrong';
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
  print('=== General Error ===');
  print('Error: $e');
  print('Stack: ${StackTrace.current}');
  return Left(ServerFailure(message: e.toString()));
  }
  }
}

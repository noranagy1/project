// ============================================================
// qr_repository_impl.dart
// ============================================================

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/errors/failure.dart';
import 'qr_data_source.dart';
import 'qr_model.dart';
import 'qr_repository.dart';

@Injectable(as: QrRepository)
class QrRepositoryImpl implements QrRepository {
  final QrDataSource _qrDataSource;
  QrRepositoryImpl(this._qrDataSource);

  @override
  Future<Either<Failure, QrModel>> getMyQr() async {
    try {
      final result = await _qrDataSource.getMyQr();
      return Right(result);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? e.message ?? 'Something went wrong';
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

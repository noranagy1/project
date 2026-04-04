
import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/failure.dart';
import 'qr_model.dart';

abstract class QrRepository {
  Future<Either<Failure, QrModel>> getMyQr();
}

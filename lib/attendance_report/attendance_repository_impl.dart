import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/errors/failure.dart';
import 'attendance_data_source.dart';
import 'attendance_model.dart';
import 'attendance_repository.dart';

@Injectable(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDataSource _dataSource;
  AttendanceRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, AttendanceModel>> getReport() async {
    try {
      final result = await _dataSource.getReport();
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? e.message ?? 'Something went wrong'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
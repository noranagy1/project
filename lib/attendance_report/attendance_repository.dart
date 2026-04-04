import 'package:dartz/dartz.dart';
import 'package:new_project/core/errors/failure.dart';
import 'attendance_model.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceModel>> getReport();
}
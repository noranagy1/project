import 'attendance_model.dart';

abstract class AttendanceDataSource {
  Future<AttendanceModel> getReport();
}
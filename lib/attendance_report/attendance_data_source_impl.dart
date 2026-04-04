import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'attendance_data_source.dart';
import 'attendance_model.dart';

@Injectable(as: AttendanceDataSource)
class AttendanceDataSourceImpl implements AttendanceDataSource {
  final Dio dio;
  AttendanceDataSourceImpl(this.dio);

  @override
  Future<AttendanceModel> getReport() async {
    final response = await dio.get(
      AppConst.attendanceReportEndPoint,
      options: Options(
        headers: {'Authorization': 'Bearer ${UserSession.token}'},
      ),
    );
    if (response.statusCode == 200) {
      return AttendanceModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch report');
    }
  }
}
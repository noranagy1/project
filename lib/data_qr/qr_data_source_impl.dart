// ============================================================
// qr_data_source_impl.dart
// ============================================================

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/user_session/user_session.dart';

import '../core/app-const/app_const.dart';
import 'qr_data_source.dart';
import 'qr_model.dart';
@Injectable(as: QrDataSource)
class QrDataSourceImpl implements QrDataSource {
  final Dio dio;
  QrDataSourceImpl(this.dio);

  @override
  Future<QrModel> getMyQr() async {
    final response = await dio.get(
      AppConst.myQrEndPoint,
      options: Options(
        headers: {

          'Authorization': 'Bearer ${UserSession.token}',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return QrModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch QR');
    }
  }
}

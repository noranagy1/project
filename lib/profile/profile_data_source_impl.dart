import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:new_project/core/app-const/app_const.dart';
import 'package:new_project/core/user_session/user_session.dart';
import 'profile_data_source.dart';
import 'profile_model.dart';

@Injectable(as: ProfileDataSource)
class ProfileDataSourceImpl implements ProfileDataSource {
  final Dio dio;
  ProfileDataSourceImpl(this.dio);

  Options get _options => Options(
    headers: {'Authorization': 'Bearer ${UserSession.token}'},
  );

  @override
  Future<ProfileModel> getProfile() async {
    final response = await dio.get(
      AppConst.employeeProfileEndPoint,
      options: _options,
    );
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  @override
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final response = await dio.put(
      AppConst.updateProfileEndPoint,
      data: {'name': name, 'email': email},
      options: _options,
    );
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
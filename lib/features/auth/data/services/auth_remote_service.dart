import 'package:dio/dio.dart';

import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
class AuthRemoteService {
  final Dio dio;

  AuthRemoteService(this.dio);

  Future<ApiResult<void>> register({
    required String email,
    required String password,
  }) async {
    return safeApiCall<void>(() async {
      await dio.post(
        '/api/User/register',
        data: {
          'userEmail': email,
          'password': password,
        },
      );
    });
  }

  Future<ApiResult<String>> login({
    required String email,
    required String password,
  }) async {
    return safeApiCall<String>(() async {
      final response = await dio.get(
        '/api/User/getusercode',
        queryParameters: {
          'UserEmail': email,
          'Password': password,
        },
      );

      return response.data['usercode'] as String;
    });
  }
}
import 'package:dio/dio.dart';

import 'api_result.dart';

Future<ApiResult<T>> safeApiCall<T>(
    Future<T> Function() request,
    ) async {
  try {
    final data = await request();

    return ApiResult.success(data);
  } on DioException catch (e) {
    return ApiResult.failure(
      e.message ?? 'Network request failed',
    );
  } catch (e) {
    return ApiResult.failure(
      'Something went wrong',
    );
  }
}
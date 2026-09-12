import '../../../../core/helpers/session.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../domain/repositories/profile_repository.dart';
import '../services/profile_remote_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteService _remoteService;

  ProfileRepositoryImpl(this._remoteService);

  @override
  Future<ApiResult<String?>> getEmail() async {
    try {
      final email = await Session.getEmail();
      return ApiResult.success(email);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<String?>> getUsercode() async {
    try {
      final usercode = await Session.getUsercode();
      return ApiResult.success(usercode);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> logout() async {
    try {
      await Session.clearSession();
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> changePassword(String usercode, String newPassword) async {
    return safeApiCall(() => _remoteService.changePassword(usercode, newPassword));
  }

  @override
  Future<ApiResult<void>> verifyPassword(String email, String password) async {
    final result = await safeApiCall<String>(() => _remoteService.verifyPassword(email, password));
    if (result is ApiSuccess<String>) {
      return ApiResult.success(null); // Return success if usercode is retrieved
    }
    return ApiResult.failure((result as ApiFailure).message);
  }

  @override
  Future<ApiResult<void>> deleteAccount(String usercode) async {
    final result = await safeApiCall(() => _remoteService.deleteAccount(usercode));
    if (result is ApiSuccess<void>) {
      await Session.clearSession();
    }
    return result;
  }
}

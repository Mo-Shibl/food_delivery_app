import '../../../../core/networking/api_result.dart';

abstract class ProfileRepository {
  Future<ApiResult<String?>> getEmail();
  Future<ApiResult<String?>> getUsercode();
  Future<ApiResult<void>> logout();
  Future<ApiResult<void>> changePassword(String usercode, String newPassword);
  Future<ApiResult<void>> verifyPassword(String email, String password);
  Future<ApiResult<void>> deleteAccount(String usercode);
}

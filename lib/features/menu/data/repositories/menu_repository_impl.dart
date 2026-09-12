import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../services/menu_remote_service.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteService remoteService;

  MenuRepositoryImpl(this.remoteService);

  @override
  Future<ApiResult<List<MenuItem>>> getAllItems() {
    return safeApiCall(() => remoteService.getAllItems());
  }

  @override
  Future<ApiResult<List<MenuItem>>> searchItems(String query) {
    return safeApiCall(() => remoteService.searchItems(query));
  }

  @override
  Future<ApiResult<List<MenuItem>>> sortItemsByPrice(bool ascending) {
    final direction = ascending ? 'asc' : 'desc';
    return safeApiCall(() => remoteService.sortItemsByPrice(direction));
  }
}

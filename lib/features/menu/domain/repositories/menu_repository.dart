import '../../../../core/networking/api_result.dart';
import '../entities/menu_item.dart';

abstract class MenuRepository {
  Future<ApiResult<List<MenuItem>>> getAllItems();
  Future<ApiResult<List<MenuItem>>> searchItems(String query);
  Future<ApiResult<List<MenuItem>>> sortItemsByPrice(bool ascending);
}

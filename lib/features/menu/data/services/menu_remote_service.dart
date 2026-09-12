import 'package:dio/dio.dart';
import '../models/menu_item_model.dart';

class MenuRemoteService {
  final Dio dio;

  MenuRemoteService(this.dio);

  Future<List<MenuItemModel>> getAllItems() async {
    final response = await dio.get('/api/Restaurant/items');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => MenuItemModel.fromJson(json)).toList();
  }

  Future<List<MenuItemModel>> searchItems(String query) async {
    final response = await dio.get(
      '/api/Restaurant/items',
      queryParameters: {'ItemName': query},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => MenuItemModel.fromJson(json)).toList();
  }

  Future<List<MenuItemModel>> sortItemsByPrice(String direction) async {
    final response = await dio.get(
      '/api/Restaurant/items',
      queryParameters: {'sortbyprice': direction},
    );
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => MenuItemModel.fromJson(json)).toList();
  }
}

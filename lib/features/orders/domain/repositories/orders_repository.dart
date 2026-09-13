import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_line.dart';


import '../entities/master_order.dart';
import '../entities/order_line.dart';

abstract class OrdersRepository {
  Future<ApiResult<List<MasterOrder>>> getOrders();

  Future<ApiResult<List<OrderLine>>> getOrderDetails(int masterId);

  Future<ApiResult<MasterOrder>> placeOrder(
    int restaurantId,
    List<CartLine> lines,
  );

  Future<ApiResult<void>> deleteOrderLine(int orderId);

  Future<ApiResult<void>> cancelMasterOrder(int masterId);
}
import 'package:food_delivery_app/core/networking/api_result.dart';
import 'package:food_delivery_app/core/networking/safe_api_call.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_line.dart';


import '../../domain/entities/master_order.dart';
import '../../domain/entities/order_line.dart';
import '../../domain/repositories/orders_repository.dart';
import '../services/orders_remote_service.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteService remoteService;

  OrdersRepositoryImpl(this.remoteService);

  @override
  Future<ApiResult<List<MasterOrder>>> getOrders() {
    return safeApiCall(
      () => remoteService.getOrders(),
    );
  }

  @override
  Future<ApiResult<List<OrderLine>>> getOrderDetails(int masterId) {
    return safeApiCall(
      () => remoteService.getOrderDetails(masterId),
    );
  }

  @override
  Future<ApiResult<MasterOrder>> placeOrder(
    int restaurantId,
    List<CartLine> lines,
  ) {
    return safeApiCall(
      () => remoteService.placeOrder(restaurantId, lines),
    );
  }

  @override
  Future<ApiResult<void>> deleteOrderLine(int orderId) {
    return safeApiCall(
      () => remoteService.deleteOrderLine(orderId),
    );
  }

  @override
  Future<ApiResult<void>> cancelMasterOrder(int masterId) {
    return safeApiCall(
      () => remoteService.cancelMasterOrder(masterId),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/networking/api_result.dart';
import '../../domain/entities/master_order.dart';
import '../../domain/entities/order_line.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository repository;

  OrdersCubit(this.repository) : super(const OrdersInitial());

  Future<void> getOrders() async {
    emit(const OrdersLoading());

    final result = await repository.getOrders();

    if (result is ApiSuccess<List<MasterOrder>>) {
      emit(OrdersSuccess(result.data));
    } else if (result is ApiFailure<List<MasterOrder>>) {
      emit(OrdersError(result.message));
    }
  }

  Future<void> getOrderDetails(int masterId) async {
    emit(const OrderDetailsLoading());

    final result = await repository.getOrderDetails(masterId);

    if (result is ApiSuccess<List<OrderLine>>) {
      emit(OrderDetailsSuccess(result.data));
    } else if (result is ApiFailure<List<OrderLine>>) {
      emit(OrderDetailsError(result.message));
    }
  }

  Future<bool> deleteOrderLine(int orderId, int masterId) async {
    final result = await repository.deleteOrderLine(orderId);

    if (result is ApiSuccess<void>) {
      await getOrderDetails(masterId);
      return true;
    }

    if (result is ApiFailure<void>) {
      emit(OrderDetailsError(result.message));
    }

    return false;
  }

  Future<bool> cancelMasterOrder(int masterId) async {
    final result = await repository.cancelMasterOrder(masterId);

    if (result is ApiSuccess<void>) {
      await getOrders();
      return true;
    }

    if (result is ApiFailure<void>) {
      emit(OrdersError(result.message));
    }

    return false;
  }
}
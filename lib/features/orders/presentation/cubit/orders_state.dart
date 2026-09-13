import '../../domain/entities/master_order.dart';
import '../../domain/entities/order_line.dart';

sealed class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersSuccess extends OrdersState {
  final List<MasterOrder> orders;

  const OrdersSuccess(this.orders);
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);
}

class OrderDetailsLoading extends OrdersState {
  const OrderDetailsLoading();
}

class OrderDetailsSuccess extends OrdersState {
  final List<OrderLine> lines;

  const OrderDetailsSuccess(this.lines);
}

class OrderDetailsError extends OrdersState {
  final String message;

  const OrderDetailsError(this.message);
}
import 'package:dio/dio.dart';
import 'package:food_delivery_app/core/helpers/session.dart';
import 'package:food_delivery_app/features/cart/domain/entities/cart_line.dart';

import '../../domain/entities/master_order.dart';
import '../../domain/entities/order_line.dart';


class OrdersRemoteService {
  final Dio dio;

  OrdersRemoteService(this.dio);

Future<String> _getUsercode() async {
  final usercode = await Session.getUsercode();

  if (usercode == null || usercode.isEmpty) {
    throw Exception('User session not found');
  }

  return usercode;
}
  Future<List<MasterOrder>> getOrders() async {
    final usercode = await _getUsercode();

    final response = await dio.get(
      '/api/Order',
      queryParameters: {
        'apikey': usercode,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data.map((json) {
      return MasterOrder(
        masterID: json['masterID'] as int,
        userID: json['userID'] as int,
        usercode: json['usercode'] as String,
        restaurantID: json['restaurantID'] as int,
        grandtotal: (json['grandtotal'] as num).toDouble(),
      );
    }).toList();
  }

  Future<List<OrderLine>> getOrderDetails(int masterId) async {
    final usercode = await _getUsercode();

    final response = await dio.get(
      '/api/Order/$masterId',
      queryParameters: {
        'apikey': usercode,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data.map((json) {
      return OrderLine(
        orderID: json['orderID'] as int,
        userID: json['userID'] as String,
        itemName: json['itemName'] as String,
        quantity: json['quantity'] as int,
        itemPrice: (json['itemPrice'] as num).toDouble(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
        masterID: json['masterID'] as int,
      );
    }).toList();
  }

Future<MasterOrder> placeOrder(
  int restaurantId,
  List<CartLine> lines,
) async {
  final usercode = await _getUsercode();

  final response = await dio.post(
    '/api/Order/$restaurantId/makeorder',
    queryParameters: {
      'apikey': usercode,
    },
    data: {
      'menuDTO': lines.map((line) {
        return {
          'itemName': line.itemName,
          'quantity': line.quantity,
        };
      }).toList(),
    },
  );

  print( 'lllllllllllllllll PLACE ORDER RESPONSE: ${response.data}');

  final json = response.data as Map<String, dynamic>;

  final fullOrder = json['fullorder'] as List<dynamic>;
  final firstLine = fullOrder.first as Map<String, dynamic>;

  return MasterOrder(
    masterID: firstLine['masterID'] as int,
    userID: 0,
    usercode: usercode,
    restaurantID: restaurantId,
    grandtotal: (json['grandTotal'] as num).toDouble(),
  );
}
  Future<void> deleteOrderLine(int orderId) async {
    final usercode = await _getUsercode();

    await dio.delete(
      '/api/Order/$orderId',
      queryParameters: {
        'apikey': usercode,
      },
    );
  }

  Future<void> cancelMasterOrder(int masterId) async {
    final usercode = await _getUsercode();

    await dio.delete(
      '/api/Order/master/$masterId',
      queryParameters: {
        'apikey': usercode,
      },
    );
  }
}
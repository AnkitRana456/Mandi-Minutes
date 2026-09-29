import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import '../models/order_models.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<Order> checkout(String deliveryAddress, String paymentMethod) async {
    final response = await _apiClient.post(
      ApiConstants.checkout,
      data: {
        'deliveryAddress': deliveryAddress,
        'paymentMethod': paymentMethod, // 'COD' or 'ONLINE'
      },
    );
    return Order.fromJson(response.data);
  }

  Future<List<Order>> getUserOrders() async {
    final response = await _apiClient.get(ApiConstants.userOrders);
    return (response.data as List<dynamic>)
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

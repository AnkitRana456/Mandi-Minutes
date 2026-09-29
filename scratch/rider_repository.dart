import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';

class RiderRepository {
  final ApiClient _apiClient;

  RiderRepository(this._apiClient);

  Future<List<Order>> getAssignedOrders() async {
    return [];
  }

  Future<Order> updateOrderStatus(int orderId, String status) async {
    final response = await _apiClient.patch(
      '${ApiConstants.businessOrders}/$orderId/status', // Placeholder endpoint
      queryParameters: {'status': status},
    );
    return Order.fromJson(response.data);
  }

  Future<bool> generateDeliveryOtp(String referenceId, String phoneNumber) async {
    final response = await _apiClient.post(
      '/otp/sendOtp',
      data: {
        'referenceId': referenceId,
        'phoneNumber': phoneNumber,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyDeliveryOtp(int orderId, String referenceId, String phoneNumber, String otp) async {
    final response = await _apiClient.post(
      '/rider/orders/$orderId/deliver',
      data: {
        'referenceId': referenceId,
        'phoneNumber': phoneNumber,
        'otp': otp,
      },
    );
    return response.statusCode == 200;
  }
}

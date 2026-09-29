import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import '../models/cart_models.dart';

class CartRepository {
  final ApiClient _apiClient;

  CartRepository(this._apiClient);

  Future<CartResponse> getCart() async {
    final response = await _apiClient.get(ApiConstants.getCart);
    return CartResponse.fromJson(response.data);
  }

  Future<CartResponse> addToCart(int productId, int quantity) async {
    final response = await _apiClient.post(
      ApiConstants.addToCart,
      data: {
        'productId': productId,
        'quantity': quantity,
      },
    );
    return CartResponse.fromJson(response.data);
  }

  Future<CartResponse> updateCartItem(int productId, int quantity) async {
    final response = await _apiClient.put(
      ApiConstants.updateCartItem,
      queryParameters: {
        'productId': productId,
        'quantity': quantity,
      },
    );
    return CartResponse.fromJson(response.data);
  }

  Future<CartResponse> deleteCartItem(int productId) async {
    final response = await _apiClient.delete(
      ApiConstants.deleteCartItem,
      queryParameters: {
        'productId': productId,
      },
    );
    return CartResponse.fromJson(response.data);
  }

  Future<void> clearCart() async {
    await _apiClient.delete(ApiConstants.clearCart);
  }
}

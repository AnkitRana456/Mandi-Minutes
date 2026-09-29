import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import '../models/shopkeeper_models.dart';

class ShopkeeperRepository {
  final ApiClient _apiClient;

  ShopkeeperRepository(this._apiClient);

  Future<Product> addProduct(CreateProductRequest request) async {
    final response = await _apiClient.post(
      ApiConstants.businessAddProduct,
      data: request.toJson(),
    );
    return Product.fromJson(response.data);
  }

  Future<List<Product>> getMyProducts() async {
    final response = await _apiClient.get(ApiConstants.businessProducts);
    return (response.data as List<dynamic>)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> updateStock(int productId, int stock, int reservedStock) async {
    final response = await _apiClient.patch(
      ApiConstants.businessUpdateStock,
      queryParameters: {
        'productId': productId,
        'stock': stock,
        'reservedStock': reservedStock,
      },
    );
    return Product.fromJson(response.data);
  }

  Future<List<OrderItem>> getShopkeeperOrders() async {
    final response = await _apiClient.get(ApiConstants.businessOrders);
    return (response.data as List<dynamic>)
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Order> updateOrderStatus(int orderId, String status) async {
    final response = await _apiClient.put(
      ApiConstants.businessUpdateOrderStatus,
      queryParameters: {
        'orderId': orderId,
        'status': status, // e.g. CONFIRMED, OUT_FOR_DELIVERY, DELIVERED
      },
    );
    return Order.fromJson(response.data);
  }
}

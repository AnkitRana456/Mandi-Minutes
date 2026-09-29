import 'package:mm_frontend/core/network/api_client.dart';
import '../models/admin_models.dart';

class AdminRepository {
  // ignore: unused_field
  final ApiClient _apiClient;

  AdminRepository(this._apiClient);

  Future<List<UserResponse>> getAllUsers() async {
    // Return mock data for UI testing since backend Admin endpoints don't exist yet
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      UserResponse(id: 1, userName: 'John Doe', email: 'john@example.com', role: 'CUSTOMER'),
      UserResponse(id: 2, userName: 'Alice Smith', email: 'alice@shop.com', role: 'BUSINESS'),
      UserResponse(id: 3, userName: 'Bob Rider', email: 'bob@delivery.com', role: 'RIDER'),
      UserResponse(id: 4, userName: 'Admin User', email: 'admin@mandiminutes.com', role: 'ADMIN'),
    ];
  }

  Future<void> deleteUser(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Simulate successful deletion
  }

  Future<List<StoreResponse>> getAllStores() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      StoreResponse(storeId: 1, name: 'Fresh Vegetables Mart', address: '123 Green Valley', contactNumber: '9876543210'),
      StoreResponse(storeId: 2, name: 'Daily Dairy & Groceries', address: '456 Milk Street', contactNumber: '9123456789'),
      StoreResponse(storeId: 3, name: 'Sunrise Organic Produce', address: '789 Sun Avenue', contactNumber: '9988776655'),
    ];
  }

  Future<StoreResponse> addStore(StoreRequest request) async {
    await Future.delayed(const Duration(seconds: 1));
    return StoreResponse(
      storeId: DateTime.now().millisecondsSinceEpoch,
      name: request.name,
      address: request.address,
      contactNumber: request.contactNumber,
    );
  }
}

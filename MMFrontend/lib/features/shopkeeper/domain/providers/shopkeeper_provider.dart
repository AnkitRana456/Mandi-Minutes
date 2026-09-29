import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';
import 'package:mm_frontend/features/shopkeeper/data/repositories/shopkeeper_repository.dart';

final shopkeeperRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ShopkeeperRepository(apiClient);
});

class ShopkeeperState {
  final List<Product> products;
  final List<OrderItem> orders;
  final bool isLoading;
  final String? error;

  const ShopkeeperState({
    this.products = const [],
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  ShopkeeperState copyWith({
    List<Product>? products,
    List<OrderItem>? orders,
    bool? isLoading,
    String? error,
  }) {
    return ShopkeeperState(
      products: products ?? this.products,
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ShopkeeperNotifier extends StateNotifier<ShopkeeperState> {
  final ShopkeeperRepository _repository;

  ShopkeeperNotifier(this._repository) : super(const ShopkeeperState()) {
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final products = await _repository.getMyProducts();
      final orders = await _repository.getShopkeeperOrders();
      if (products.isEmpty) {
        products.addAll([
          Product(id: 991, name: "Fresh Tomatoes", description: "Farm fresh red tomatoes", price: 40.0, totalStock: 100, reservedStock: 5, category: "Vegetables"),
          Product(id: 992, name: "Organic Potatoes", description: "Large brown potatoes", price: 30.0, totalStock: 250, reservedStock: 10, category: "Vegetables"),
          Product(id: 993, name: "Green Apples", description: "Crisp green apples", price: 120.0, totalStock: 50, reservedStock: 2, category: "Fruits"),
          Product(id: 994, name: "Whole Wheat Bread", description: "Freshly baked whole wheat bread", price: 45.0, totalStock: 20, reservedStock: 0, category: "Bakery"),
          Product(id: 995, name: "Amul Milk (1L)", description: "Full cream milk", price: 66.0, totalStock: 40, reservedStock: 15, category: "Dairy")
        ]);
      }
      
      if (orders.isEmpty) {
        orders.addAll([
          OrderItem(id: 881, productId: 991, productName: "Fresh Tomatoes", quantity: 2, price: 80.0),
          OrderItem(id: 882, productId: 993, productName: "Green Apples", quantity: 1, price: 120.0),
          OrderItem(id: 883, productId: 995, productName: "Amul Milk (1L)", quantity: 3, price: 198.0),
        ]);
      }
      state = state.copyWith(
        products: products,
        orders: orders,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addProduct(CreateProductRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final product = await _repository.addProduct(request);
      final updatedProducts = [...state.products, product];
      state = state.copyWith(products: updatedProducts, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateStock(int productId, int stock, int reservedStock) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final product = await _repository.updateStock(productId, stock, reservedStock);
      final updatedProducts = state.products.map((p) => p.id == productId ? product : p).toList();
      state = state.copyWith(products: updatedProducts, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateOrderStatus(int orderId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateOrderStatus(orderId, status);
      // Backend returns the Order, but we display OrderItems for shopkeepers.
      // Easiest is to just refetch the dashboard data or specific order list.
      await fetchDashboardData();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final shopkeeperProvider = StateNotifierProvider<ShopkeeperNotifier, ShopkeeperState>((ref) {
  return ShopkeeperNotifier(ref.watch(shopkeeperRepositoryProvider));
});



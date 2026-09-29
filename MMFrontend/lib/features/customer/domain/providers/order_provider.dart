import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import 'package:mm_frontend/features/customer/data/repositories/order_repository.dart';
import 'cart_provider.dart';

final orderRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderRepository(apiClient);
});

class OrderState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;
  final Ref _ref;

  OrderNotifier(this._repository, this._ref) : super(const OrderState()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getUserOrders();
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Order?> checkout(String deliveryAddress, String paymentMethod) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final order = await _repository.checkout(deliveryAddress, paymentMethod);
      
      // Update order list
      final updatedOrders = [order, ...state.orders];
      state = state.copyWith(orders: updatedOrders, isLoading: false);
      
      // Refresh cart (which should now be empty)
      await _ref.read(cartProvider.notifier).fetchCart();
      
      return order;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier(ref.watch(orderRepositoryProvider), ref);
});

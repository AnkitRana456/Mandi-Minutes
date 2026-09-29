import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/customer/data/models/cart_models.dart';
import 'package:mm_frontend/features/customer/data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CartRepository(apiClient);
});

class CartState {
  final CartResponse? cart;
  final bool isLoading;
  final String? error;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    CartResponse? cart,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _repository;

  CartNotifier(this._repository) : super(const CartState()) {
    fetchCart();
  }

  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _repository.getCart();
      state = state.copyWith(cart: cart, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _repository.addToCart(productId, quantity);
      state = state.copyWith(cart: cart, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateItem(int productId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _repository.updateCartItem(productId, quantity);
      state = state.copyWith(cart: cart, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> removeItem(int productId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final cart = await _repository.deleteCartItem(productId);
      state = state.copyWith(cart: cart, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.clearCart();
      state = state.copyWith(
        cart: CartResponse(items: [], totalItemsCount: 0, totalCartValue: 0.0),
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref.watch(cartRepositoryProvider));
});

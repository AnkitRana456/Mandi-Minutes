import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import 'package:mm_frontend/features/rider/data/repositories/rider_repository.dart';

final riderRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RiderRepository(apiClient);
});

class RiderState {
  final List<Order> assignedOrders;
  final bool isLoading;
  final String? error;
  final bool isOtpGenerated;

  const RiderState({
    this.assignedOrders = const [],
    this.isLoading = false,
    this.error,
    this.isOtpGenerated = false,
  });

  RiderState copyWith({
    List<Order>? assignedOrders,
    bool? isLoading,
    String? error,
    bool? isOtpGenerated,
  }) {
    return RiderState(
      assignedOrders: assignedOrders ?? this.assignedOrders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOtpGenerated: isOtpGenerated ?? this.isOtpGenerated,
    );
  }
}

class RiderNotifier extends StateNotifier<RiderState> {
  final RiderRepository _repository;

  RiderNotifier(this._repository) : super(const RiderState()) {
    fetchAssignedOrders();
  }

  Future<void> fetchAssignedOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getAssignedOrders();
      state = state.copyWith(assignedOrders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> updateOrderStatus(int orderId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.updateOrderStatus(orderId, status);
      await fetchAssignedOrders();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> generateOtp(int orderId, String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null, isOtpGenerated: false);
    try {
      final success = await _repository.generateDeliveryOtp('ORDER_$orderId', phoneNumber);
      state = state.copyWith(isLoading: false, isOtpGenerated: success);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(int orderId, String phoneNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _repository.verifyDeliveryOtp(orderId, 'ORDER_$orderId', phoneNumber, otp);
      if (success) {
        state = state.copyWith(isOtpGenerated: false);
      }
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final riderProvider = StateNotifierProvider<RiderNotifier, RiderState>((ref) {
  return RiderNotifier(ref.watch(riderRepositoryProvider));
});

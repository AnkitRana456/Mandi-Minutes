import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/admin/data/models/admin_models.dart';
import 'package:mm_frontend/features/admin/data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminRepository(apiClient);
});

class AdminState {
  final List<UserResponse> users;
  final List<StoreResponse> stores;
  final bool isLoading;
  final String? error;

  const AdminState({
    this.users = const [],
    this.stores = const [],
    this.isLoading = false,
    this.error,
  });

  AdminState copyWith({
    List<UserResponse>? users,
    List<StoreResponse>? stores,
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      users: users ?? this.users,
      stores: stores ?? this.stores,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdminNotifier extends StateNotifier<AdminState> {
  final AdminRepository _repository;

  AdminNotifier(this._repository) : super(const AdminState());

  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final users = await _repository.getAllUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> deleteUser(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteUser(id);
      final updatedUsers = state.users.where((u) => u.id != id).toList();
      state = state.copyWith(users: updatedUsers, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> fetchStores() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final stores = await _repository.getAllStores();
      state = state.copyWith(stores: stores, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> addStore(StoreRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final store = await _repository.addStore(request);
      final updatedStores = [...state.stores, store];
      state = state.copyWith(stores: updatedStores, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final adminProvider = StateNotifierProvider<AdminNotifier, AdminState>((ref) {
  return AdminNotifier(ref.watch(adminRepositoryProvider));
});

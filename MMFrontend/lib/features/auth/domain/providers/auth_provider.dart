import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import 'package:mm_frontend/core/storage/preferences_storage.dart';
import 'package:mm_frontend/core/storage/secure_storage.dart';
import '../../data/models/auth_response.dart';
import '../../data/models/registration_requests.dart';
import '../../data/repositories/auth_repository.dart';

// --- Dependencies ---

final secureStorageProvider = Provider((ref) => SecureStorageService());

final apiClientProvider = Provider((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage: storage);
});

final authRepositoryProvider = Provider((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRepository(client);
});

final preferencesProvider = Provider<PreferencesStorageService>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});

// --- State ---

enum AuthStatus { initial, authenticated, unauthenticated }

class UserSession {
  final int id;
  final String email;
  final String role;
  final String name;

  UserSession({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
  });
}

class AuthState {
  final AuthStatus status;
  final UserSession? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserSession? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error, // intentionally allow nulling
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- Notifier ---

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _secureStorage;
  final PreferencesStorageService _preferences;

  AuthNotifier(this._repository, this._secureStorage, this._preferences)
      : super(const AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _secureStorage.read(StorageKeys.accessToken);
      if (token != null) {
        // Restore session from prefs
        final id = _preferences.getString(StorageKeys.userId);
        final email = _preferences.getString(StorageKeys.userEmail);
        final role = _preferences.getString(StorageKeys.userRole);
        final name = _preferences.getString(StorageKeys.userName);

        if (id != null && email != null && role != null && name != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: UserSession(
              id: int.parse(id),
              email: email,
              role: role,
              name: name,
            ),
            isLoading: false,
          );
          return;
        }
      }
      state = state.copyWith(status: AuthStatus.unauthenticated, isLoading: false);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, isLoading: false);
    }
  }

  Future<bool> login(String email, String password, String role) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.login(email, password, role);
      await _handleSuccessfulAuth(response);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> registerCustomer(CustomerRegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.registerCustomer(request);
      await _handleSuccessfulAuth(response);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> registerBusiness(BusinessRegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.registerBusiness(request);
      await _handleSuccessfulAuth(response);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> registerRider(RiderRegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.registerRider(request);
      await _handleSuccessfulAuth(response);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> _handleSuccessfulAuth(AuthResponse response) async {
    if (response.userId != null) {
      await _preferences.setString(StorageKeys.userId, response.userId.toString());
      await _preferences.setString(StorageKeys.userEmail, response.email ?? '');
      await _preferences.setString(StorageKeys.userRole, response.role ?? '');
      await _preferences.setString(StorageKeys.userName, response.userName ?? '');

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: UserSession(
          id: response.userId!,
          email: response.email ?? '',
          role: response.role ?? '',
          name: response.userName ?? '',
        ),
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid response from server.',
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _repository.logout();
    await _preferences.remove(StorageKeys.userId);
    await _preferences.remove(StorageKeys.userEmail);
    await _preferences.remove(StorageKeys.userRole);
    await _preferences.remove(StorageKeys.userName);
    
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(secureStorageProvider),
    ref.watch(preferencesProvider),
  );
});

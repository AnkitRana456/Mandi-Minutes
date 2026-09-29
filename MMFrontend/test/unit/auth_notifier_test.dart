import 'package:flutter_test/flutter_test.dart';
import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/auth/data/models/auth_response.dart';
import '../mocks/mock_repositories.dart';

class FakeSecureStorage extends MockSecureStorage {
  @override
  Future<String?> read(String key) async => null;
  @override
  Future<void> write(String key, String value) async {}
  @override
  Future<void> delete(String key) async {}
}

class FakePreferencesStorage extends MockPreferencesStorage {
  @override
  Future<bool> setString(String key, String value) async => true;
  @override
  Future<bool> remove(String key) async => true;
}

class FakeAuthRepository extends MockAuthRepository {
  bool shouldFail = false;
  
  @override
  Future<AuthResponse> login(String email, String password, String role) async {
    if (shouldFail) throw Exception('Invalid credentials');
    return AuthResponse(token: 'test_token', userId: 1, email: 'test@test.com', role: 'CUSTOMER', userName: 'Test User');
  }
  @override
  Future<void> logout() async {}
}

void main() {
  late FakeAuthRepository mockAuthRepository;
  late FakeSecureStorage mockSecureStorage;
  late FakePreferencesStorage mockPreferencesStorage;
  late AuthNotifier authNotifier;

  setUp(() {
    mockAuthRepository = FakeAuthRepository();
    mockSecureStorage = FakeSecureStorage();
    mockPreferencesStorage = FakePreferencesStorage();

    authNotifier = AuthNotifier(
      mockAuthRepository,
      mockSecureStorage,
      mockPreferencesStorage,
    );
  });

  group('AuthNotifier Unit Tests', () {
    test('initial state should be unauthenticated after checkAuth fails', () async {
      await Future.delayed(Duration.zero);
      expect(authNotifier.state.status, AuthStatus.unauthenticated);
    });

    test('login success should update state to authenticated', () async {
      final success = await authNotifier.login('test@test.com', 'password', 'CUSTOMER');
      expect(success, true);
      expect(authNotifier.state.status, AuthStatus.authenticated);
      expect(authNotifier.state.user?.id, 1);
    });

    test('login failure should set error state', () async {
      mockAuthRepository.shouldFail = true;
      final success = await authNotifier.login('test@test.com', 'wrong', 'CUSTOMER');
      expect(success, false);
      expect(authNotifier.state.status, AuthStatus.unauthenticated);
    });

    test('logout should clear storage and state', () async {
      await authNotifier.logout();
      expect(authNotifier.state.status, AuthStatus.unauthenticated);
    });
  });
}

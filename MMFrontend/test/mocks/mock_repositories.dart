import 'package:mockito/mockito.dart';
import 'package:mm_frontend/features/auth/data/repositories/auth_repository.dart';
import 'package:mm_frontend/features/customer/data/repositories/cart_repository.dart';
import 'package:mm_frontend/core/storage/secure_storage.dart';
import 'package:mm_frontend/core/storage/preferences_storage.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockCartRepository extends Mock implements CartRepository {}
class MockSecureStorage extends Mock implements SecureStorageService {}
class MockPreferencesStorage extends Mock implements PreferencesStorageService {}

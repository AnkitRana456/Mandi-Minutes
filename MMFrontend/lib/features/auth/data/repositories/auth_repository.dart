import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import '../models/auth_response.dart';
import '../models/registration_requests.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<AuthResponse> login(String email, String password, String role) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
        'role': role,
      },
    );

    final authResponse = AuthResponse.fromJson(response.data);
    
    if (authResponse.token != null) {
      await _apiClient.saveTokens(
        accessToken: authResponse.token!,
        refreshToken: authResponse.refreshToken ?? '',
      );
    }
    
    return authResponse;
  }

  Future<AuthResponse> registerCustomer(CustomerRegisterRequest request) async {
    return _register(ApiConstants.registerCustomer, request.toJson());
  }

  Future<AuthResponse> registerBusiness(BusinessRegisterRequest request) async {
    return _register(ApiConstants.registerBusiness, request.toJson());
  }

  Future<AuthResponse> registerRider(RiderRegisterRequest request) async {
    return _register(ApiConstants.registerRider, request.toJson());
  }

  Future<AuthResponse> _register(String path, Map<String, dynamic> data) async {
    final response = await _apiClient.post(path, data: data);
    final authResponse = AuthResponse.fromJson(response.data);
    
    if (authResponse.token != null) {
      await _apiClient.saveTokens(
        accessToken: authResponse.token!,
        refreshToken: authResponse.refreshToken ?? '',
      );
    }
    
    return authResponse;
  }

  Future<void> logout() async {
    await _apiClient.clearTokens();
  }
}

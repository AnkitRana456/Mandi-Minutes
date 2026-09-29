import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/api_exceptions.dart';
import '../storage/secure_storage.dart';

/// Centralized Dio-based API client with JWT interceptor and refresh logic.
class ApiClient {
  late final Dio _dio;
  final SecureStorageService _storage;
  bool _isRefreshing = false;

  ApiClient({required this._storage}) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(_AuthInterceptor(this));

    // Debug logging – only in debug builds
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  Dio get dio => _dio;
  SecureStorageService get storage => _storage;

  // ---------------------------------------------------------------------------
  // Convenience HTTP methods
  // ---------------------------------------------------------------------------

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.get<T>(
          path,
          queryParameters: queryParameters,
          options: options,
        ));
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.post<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        ));
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.put<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        ));
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.patch<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        ));
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _handleRequest(() => _dio.delete<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        ));
  }

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  Future<String?> getAccessToken() => _storage.read(StorageKeys.accessToken);

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(StorageKeys.accessToken, accessToken);
    await _storage.write(StorageKeys.refreshToken, refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// Attempt to refresh the access token using the stored refresh token.
  /// Returns true if successful, false otherwise.
  Future<bool> refreshAccessToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = await _storage.read(StorageKeys.refreshToken);
      if (refreshToken == null) return false;

      // Use a separate Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final generated = data['generated'] as bool? ?? false;

      if (generated && data['token'] != null) {
        await saveTokens(
          accessToken: data['token'] as String,
          refreshToken: data['refreshToken'] as String? ?? refreshToken,
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Error mapping
  // ---------------------------------------------------------------------------

  Future<Response<T>> _handleRequest<T>(Future<Response<T>> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        return _mapStatusCode(e.response);

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request cancelled.');

      default:
        if (e.error is SocketException) {
          return const NetworkException();
        }
        return ApiException(message: e.message ?? 'An unexpected error occurred.');
    }
  }

  ApiException _mapStatusCode(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to extract the backend error message
    String message = 'Something went wrong.';
    if (data is Map<String, dynamic>) {
      message = (data['message'] as String?) ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(message: message);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return const ForbiddenException();
      case 404:
        return NotFoundException(message: message);
      case 409:
        return ConflictException(message: message);
      case 500:
        return const ServerException();
      default:
        return ApiException(message: message, statusCode: statusCode);
    }
  }
}

// -----------------------------------------------------------------------------
// Auth Interceptor
// -----------------------------------------------------------------------------

class _AuthInterceptor extends Interceptor {
  final ApiClient _client;

  _AuthInterceptor(this._client);

  /// Paths that should NOT have the Authorization header attached.
  static const _publicPaths = [
    ApiConstants.login,
    ApiConstants.registerCustomer,
    ApiConstants.registerBusiness,
    ApiConstants.registerRider,
    ApiConstants.refreshToken,
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isPublic = _publicPaths.any((p) => options.path.contains(p));

    if (!isPublic) {
      final token = await _client.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If we get a 401, try to refresh the token once
    if (err.response?.statusCode == 401) {
      final refreshed = await _client.refreshAccessToken();
      if (refreshed) {
        // Retry the original request with the new token
        try {
          final token = await _client.getAccessToken();
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $token';

          final response = await _client.dio.fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          // Refresh succeeded but retry failed – pass through
        }
      }
    }

    handler.next(err);
  }
}

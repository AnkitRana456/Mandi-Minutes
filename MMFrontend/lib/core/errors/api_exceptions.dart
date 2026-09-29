/// Typed API exceptions that map to backend error responses.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Session expired. Please login again.'})
      : super(statusCode: 401, errorCode: 'UNAUTHORIZED');
}

class ForbiddenException extends ApiException {
  const ForbiddenException({super.message = 'You don\'t have permission to access this.'})
      : super(statusCode: 403, errorCode: 'FORBIDDEN');
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Requested resource not found.'})
      : super(statusCode: 404, errorCode: 'NOT_FOUND');
}

class ConflictException extends ApiException {
  const ConflictException({required super.message})
      : super(statusCode: 409, errorCode: 'CONFLICT');
}

class ValidationException extends ApiException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
  }) : super(statusCode: 400, errorCode: 'VALIDATION_FAILED');
}

class ServerException extends ApiException {
  const ServerException({super.message = 'Something went wrong. Please try again later.'})
      : super(statusCode: 500, errorCode: 'INTERNAL_SERVER_ERROR');
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'No internet connection. Please check your network.'})
      : super(statusCode: null, errorCode: 'NETWORK_ERROR');
}

class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Request timed out. Please try again.'})
      : super(statusCode: null, errorCode: 'TIMEOUT');
}

class AuthResponse {
  final String? token;
  final String? refreshToken;
  final bool generated;
  final String? message;
  final String? userName;
  final int? userId;
  final String? email;
  final String? role;

  AuthResponse({
    this.token,
    this.refreshToken,
    this.generated = false,
    this.message,
    this.userName,
    this.userId,
    this.email,
    this.role,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      generated: json['generated'] as bool? ?? false,
      message: json['message'] as String?,
      userName: json['userName'] as String?,
      userId: json['userId'] as int?,
      email: json['email'] as String?,
      role: json['role'] as String?,
    );
  }
}

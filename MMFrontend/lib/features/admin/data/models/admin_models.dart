class UserResponse {
  final int? id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final bool enabled;

  UserResponse({
    this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    this.role,
    this.enabled = true,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int?,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      enabled: json['enabled'] as bool? ?? true,
    );
  }
}

class StoreResponse {
  final int? storeId;
  final String? name;
  final String? address;
  final String? contactNumber;
  final bool active;

  StoreResponse({
    this.storeId,
    this.name,
    this.address,
    this.contactNumber,
    this.active = true,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) {
    return StoreResponse(
      storeId: json['storeId'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      contactNumber: json['contactNumber'] as String?,
      active: json['active'] as bool? ?? true,
    );
  }
}

class StoreRequest {
  final String name;
  final String address;
  final String contactNumber;

  StoreRequest({
    required this.name,
    required this.address,
    required this.contactNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'contactNumber': contactNumber,
    };
  }
}

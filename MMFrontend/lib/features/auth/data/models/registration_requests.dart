abstract class RegistrationRequest {
  Map<String, dynamic> toJson();
}

class CustomerRegisterRequest implements RegistrationRequest {
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;
  final String defaultAddress;
  final String emergencyContactPhone;

  CustomerRegisterRequest({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.role = 'CUSTOMER',
    required this.defaultAddress,
    required this.emergencyContactPhone,
  });

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
        'defaultAddress': defaultAddress,
        'emergencyContactPhone': emergencyContactPhone,
      };
}

class BusinessRegisterRequest implements RegistrationRequest {
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;
  final String businessName;
  final String gstinNumber;
  final int assignedStoreId;

  BusinessRegisterRequest({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.role = 'BUSINESS',
    required this.businessName,
    required this.gstinNumber,
    required this.assignedStoreId,
  });

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
        'businessName': businessName,
        'gstinNumber': gstinNumber,
        'assignedStoreId': assignedStoreId,
      };
}

class RiderRegisterRequest implements RegistrationRequest {
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;
  final String vehicleNumber;
  final String licenseNumber;
  final int assignedStoreId;

  RiderRegisterRequest({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.role = 'RIDER',
    required this.vehicleNumber,
    required this.licenseNumber,
    required this.assignedStoreId,
  });

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
        'vehicleNumber': vehicleNumber,
        'licenseNumber': licenseNumber,
        'assignedStoreId': assignedStoreId,
      };
}

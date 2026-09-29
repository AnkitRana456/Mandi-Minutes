/// API endpoint constants and environment configuration.
///
/// Uses 10.0.2.2 for Android emulator (maps to host machine's localhost).
/// Change to your machine's IP for physical device testing.
class ApiConstants {
  ApiConstants._();

  // ---------------------------------------------------------------------------
  // Base URLs – switch via the [baseUrl] getter or build flavors.
  // ---------------------------------------------------------------------------
  static const String devBaseUrl = 'http://localhost:8080';
  static const String stagingBaseUrl = 'https://staging-api.mandiminutes.com';
  static const String prodBaseUrl = 'https://api.mandiminutes.com';

  /// Active base URL — change this for different environments.
  static String get baseUrl => devBaseUrl;

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------
  static const String login = '/api/v1/user/login';
  static const String registerCustomer = '/api/v1/user/register/customer';
  static const String registerBusiness = '/api/v1/user/register/business';
  static const String registerRider = '/api/v1/user/register/rider';
  static const String refreshToken = '/api/v1/refreshToken/refresh';

  // ---------------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------------
  static const String getCart = '/api/v1/cart/getCart';
  static const String addToCart = '/api/v1/cart/add';
  static const String updateCartItem = '/api/v1/cart/items';
  static const String deleteCartItem = '/api/v1/cart/deleteItems';
  static const String clearCart = '/api/v1/cart/clear';

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------
  static const String checkout = '/api/v1/orders/checkout';
  static const String userOrders = '/api/v1/orders/user';

  // ---------------------------------------------------------------------------
  // Business / Shopkeeper
  // ---------------------------------------------------------------------------
  static const String businessAddProduct = '/api/v1/business/products/add';
  static const String businessProducts = '/api/v1/business/products';
  static const String businessUpdateStock = '/api/v1/business/products/stock';
  static const String businessOrders = '/api/v1/business/orders';
  static const String businessUpdateOrderStatus = '/api/v1/business/orders/zstatus';

  // ---------------------------------------------------------------------------
  // OTP (Rider only – delivery handover)
  // ---------------------------------------------------------------------------
  static const String sendOtp = '/api/v1/otp/sendOtp';
  static const String verifyOtp = '/api/v1/otp/verifyOtp';

  // ---------------------------------------------------------------------------
  // Payments
  // ---------------------------------------------------------------------------
  static const String createPaymentOrder = '/api/v1/payments/order';

  // ---------------------------------------------------------------------------
  // Public Catalog
  // ---------------------------------------------------------------------------
  static const String publicCategories = '/api/v1/public/categories';
  static const String publicPromotions = '/api/v1/public/promotions';
  static const String publicFeaturedProducts = '/api/v1/public/products/featured';
  static const String publicSearchProducts = '/api/v1/public/products/search';

  // ---------------------------------------------------------------------------
  // Timeouts
  // ---------------------------------------------------------------------------
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  // Admin endpoints
  static const String adminUsers = '/api/admin/users';
  static const String adminStores = '/api/admin/stores';
  static const String adminAddStore = '/api/admin/stores';
}

/// Storage keys used across the app.
class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userRole = 'user_role';
  static const String isLoggedIn = 'is_logged_in';
  // Admin endpoints
  static const String adminUsers = '/api/admin/users';
  static const String adminStores = '/api/admin/stores';
  static const String adminAddStore = '/api/admin/stores';
}


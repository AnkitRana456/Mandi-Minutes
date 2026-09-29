class CartResponse {
  final int? cartId;
  final int? userId;
  final List<CartItemResponse> items;
  final int totalItemsCount;
  final double totalCartValue;

  CartResponse({
    this.cartId,
    this.userId,
    this.items = const [],
    this.totalItemsCount = 0,
    this.totalCartValue = 0.0,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cartId: json['cartId'] as int?,
      userId: json['userId'] as int?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalItemsCount: json['totalItemsCount'] as int? ?? 0,
      totalCartValue: (json['totalCartValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CartItemResponse {
  final int? cartItemId;
  final int? productId;
  final String? productName;
  final String? unit;
  final double unitPrice;
  final int quantity;
  final double subTotal;
  final bool isAvailable;

  CartItemResponse({
    this.cartItemId,
    this.productId,
    this.productName,
    this.unit,
    this.unitPrice = 0.0,
    this.quantity = 0,
    this.subTotal = 0.0,
    this.isAvailable = true,
  });

  factory CartItemResponse.fromJson(Map<String, dynamic> json) {
    return CartItemResponse(
      cartItemId: json['cartItemId'] as int?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      unit: json['unit'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int? ?? 0,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }
}

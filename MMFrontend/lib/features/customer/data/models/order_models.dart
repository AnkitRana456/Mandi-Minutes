class Order {
  final int? id;
  final int? userId;
  final double totalAmount;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final String? deliveryAddress;
  final String? createdAt;
  final List<OrderItem> orderItemList;

  Order({
    this.id,
    this.userId,
    this.totalAmount = 0.0,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.deliveryAddress,
    this.createdAt,
    this.orderItemList = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      createdAt: json['createdAt'] as String?,
      orderItemList: (json['orderItemList'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final int? id;
  final int? productId;
  final String? productName;
  final int quantity;
  final double price;
  final int? shopkeeperId;

  OrderItem({
    this.id,
    this.productId,
    this.productName,
    this.quantity = 0,
    this.price = 0.0,
    this.shopkeeperId,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int?,
      productId: json['productId'] as int?,
      productName: json['productName'] as String?,
      quantity: json['quantity'] as int? ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      shopkeeperId: json['shopkeeperId'] as int?,
    );
  }
}

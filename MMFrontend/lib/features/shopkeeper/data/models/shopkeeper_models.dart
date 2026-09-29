class Product {
  final int? id;
  final String? name;
  final String? description;
  final double price;
  final int totalStock;
  final int reservedStock;
  final int? shopkeeperId;
  final String? category;
  final String? unit;
  final String? imageUrl;

  Product({
    this.id,
    this.name,
    this.description,
    this.price = 0.0,
    this.totalStock = 0,
    this.reservedStock = 0,
    this.shopkeeperId,
    this.category,
    this.unit,
    this.imageUrl,
  });

  int get availableStock => totalStock - reservedStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalStock: json['totalStock'] as int? ?? 0,
      reservedStock: json['reservedStock'] as int? ?? 0,
      shopkeeperId: json['shopkeeperId'] as int?,
      category: json['category'] as String?,
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class CreateProductRequest {
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final int reservedStock;
  final String category;
  final String? imageUrl;

  CreateProductRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.reservedStock = 0,
    required this.category,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'reservedStock': reservedStock,
      'category': category,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}

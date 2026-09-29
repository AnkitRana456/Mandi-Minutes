import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;

  CategoryModel({required this.id, required this.name, required this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }
}

class PromotionModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;

  PromotionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
    );
  }
}

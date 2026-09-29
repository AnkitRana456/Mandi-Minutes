import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:mm_frontend/features/customer/data/models/catalog_models.dart';
import 'package:mm_frontend/features/customer/data/repositories/catalog_repository.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CatalogRepository(apiClient);
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(catalogRepositoryProvider);
  return repository.getCategories();
});

final promotionsProvider = FutureProvider<List<PromotionModel>>((ref) async {
  final repository = ref.read(catalogRepositoryProvider);
  return repository.getPromotions();
});

final featuredProductsProvider = FutureProvider.family<List<Product>, String>((ref, section) async {
  final repository = ref.read(catalogRepositoryProvider);
  return repository.getFeaturedProducts(section);
});

final searchProductsProvider = FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.read(catalogRepositoryProvider);
  return repository.searchProducts(query);
});

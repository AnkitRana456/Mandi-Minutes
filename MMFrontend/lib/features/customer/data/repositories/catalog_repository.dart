import 'package:mm_frontend/core/constants/api_constants.dart';
import 'package:mm_frontend/core/network/api_client.dart';
import 'package:mm_frontend/features/customer/data/models/catalog_models.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';

class CatalogRepository {
  final ApiClient _apiClient;

  CatalogRepository(this._apiClient);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiClient.get(ApiConstants.publicCategories);
    if (response.data != null) {
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<List<PromotionModel>> getPromotions() async {
    final response = await _apiClient.get(ApiConstants.publicPromotions);
    if (response.data != null) {
      return (response.data as List)
          .map((json) => PromotionModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<List<Product>> getFeaturedProducts(String section) async {
    final response = await _apiClient.get(
      ApiConstants.publicFeaturedProducts,
      queryParameters: {'section': section},
    );
    if (response.data != null) {
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _apiClient.get(
      ApiConstants.publicSearchProducts,
      queryParameters: {'q': query},
    );
    if (response.data != null) {
      return (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
    }
    return [];
  }
}

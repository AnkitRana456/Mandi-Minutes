import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/features/customer/domain/providers/catalog_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: AppColors.textHint),
            SizedBox(height: 16),
            Text(
              'Search for fresh products',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    final searchAsync = ref.watch(searchProductsProvider(_searchQuery));

    return searchAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Text(
              'No products found matching your search.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.base),
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.shimmerBase,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: product.imageUrl != null
                    ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                    : const Icon(Icons.image, color: AppColors.textHint),
              ),
              title: Text(
                product.name ?? 'Unknown',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${product.unit ?? '1 item'} - ₹${product.price}'),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primaryGreen),
                onPressed: () {
                  // Add to cart
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text('Error: $e')),
    );
  }
}

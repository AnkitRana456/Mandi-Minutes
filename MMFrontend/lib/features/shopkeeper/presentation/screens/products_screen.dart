import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/features/shopkeeper/domain/providers/shopkeeper_provider.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopkeeperProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Products', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      body: state.isLoading && state.products.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : state.products.isEmpty
              ? _buildEmptyState(context)
              : _buildProductsList(context, ref, state.products),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/shopkeeper/add-product'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_rounded,
              size: 64,
              color: AppColors.primaryGreen.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Products Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap + to add your first product to the store',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, WidgetRef ref, List<Product> products) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(shopkeeperProvider.notifier).fetchDashboardData(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: 100),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(product: product);
        },
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  final Product product;

  const _ProductCard({required this.product});

  void _showUpdateStockDialog(BuildContext context, WidgetRef ref) {
    final stockController = TextEditingController(text: product.totalStock.toString());
    final reservedController = TextEditingController(text: product.reservedStock.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Update Stock', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Total Stock',
                prefixIcon: Icon(Icons.inventory_rounded),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reservedController,
              decoration: const InputDecoration(
                labelText: 'Reserved Stock',
                prefixIcon: Icon(Icons.lock_clock_rounded),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? product.totalStock;
              final newReserved = int.tryParse(reservedController.text) ?? product.reservedStock;

              ref.read(shopkeeperProvider.notifier).updateStock(
                    product.id!,
                    newStock,
                    newReserved,
                  );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLowStock = (product.totalStock - product.reservedStock) <= 5;
    final int availableStock = product.totalStock - product.reservedStock;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(AppRadius.md),
                image: product.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(product.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imageUrl == null
                  ? const Center(child: Icon(Icons.image_not_supported_rounded, color: AppColors.textHint))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? '',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isLowStock ? AppColors.error.withValues(alpha: 0.1) : AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_2_rounded,
                              size: 14,
                              color: isLowStock ? AppColors.error : AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Available: $availableStock',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isLowStock ? AppColors.error : AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _showUpdateStockDialog(context, ref),
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: const Text('Edit Stock'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

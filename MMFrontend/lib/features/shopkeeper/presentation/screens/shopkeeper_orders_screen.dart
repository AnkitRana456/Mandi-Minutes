import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import '../../domain/providers/shopkeeper_provider.dart';

class ShopkeeperOrdersScreen extends ConsumerWidget {
  const ShopkeeperOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shopkeeperProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Store Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      body: state.isLoading && state.orders.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : state.orders.isEmpty
              ? _buildEmptyState(context)
              : _buildOrdersList(context, ref, state.orders),
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
              color: AppColors.accentYellow.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: AppColors.accentYellow.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Orders Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          const Text(
            'Orders from customers will appear here.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<OrderItem> items) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(shopkeeperProvider.notifier).fetchDashboardData(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return _ShopkeeperOrderItemCard(item: item);
        },
      ),
    );
  }
}

class _ShopkeeperOrderItemCard extends ConsumerWidget {
  final OrderItem item;

  const _ShopkeeperOrderItemCard({required this.item});

  void _showStatusDialog(BuildContext context, WidgetRef ref) {
    final statuses = ['PENDING', 'CONFIRMED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Update Status', style: TextStyle(fontWeight: FontWeight.bold)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return ListTile(
              title: Text(
                status.replaceAll('_', ' '),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                ref.read(shopkeeperProvider.notifier).updateOrderStatus(item.id!, status);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status updated to $status'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_shipping_rounded, color: AppColors.accentYellow, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${item.id}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Product ID: ${item.productId}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${item.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider, height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_basket_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Qty: ${item.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _showStatusDialog(context, ref),
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text('Update Status'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

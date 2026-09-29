import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import '../../domain/providers/order_provider.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: orderState.isLoading && orderState.orders.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : orderState.orders.isEmpty
              ? _buildEmptyOrders(context)
              : _buildOrdersList(context, ref, orderState.orders),
    );
  }

  Widget _buildEmptyOrders(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No orders yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your past orders will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<Order> orders) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(orderProvider.notifier).fetchOrders(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _OrderCard(order: order);
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return AppColors.statusPending;
      case 'CONFIRMED':
        return AppColors.statusConfirmed;
      case 'OUT_FOR_DELIVERY':
        return AppColors.statusOutForDelivery;
      case 'DELIVERED':
        return AppColors.statusDelivered;
      case 'CANCELLED':
        return AppColors.statusCancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.parse(order.createdAt!))
        : 'Unknown Date';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    order.status ?? 'UNKNOWN',
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider),
            ),
            ...order.orderItemList.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity} × ${item.productName}',
                          style: const TextStyle(fontSize: 14, color: AppColors.text),
                        ),
                      ),
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Divider(color: AppColors.divider),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '₹${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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

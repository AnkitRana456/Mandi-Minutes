import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/features/customer/data/models/order_models.dart';
import 'package:mm_frontend/features/rider/domain/providers/rider_provider.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';

class RiderOrdersScreen extends ConsumerWidget {
  const RiderOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(riderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Deliveries', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: state.isLoading && state.assignedOrders.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : state.assignedOrders.isEmpty
              ? _buildEmptyState(context)
              : _buildOrdersList(context, ref, state.assignedOrders),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
              Icons.local_shipping_outlined,
              size: 80,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No deliveries assigned',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'You are currently idle. New orders will appear here once assigned.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<Order> orders) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(riderProvider.notifier).fetchAssignedOrders(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final order = orders[index];
          return _DeliveryCard(order: order);
        },
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Order order;

  const _DeliveryCard({required this.order});

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
    final isOutForDelivery = order.status == 'OUT_FOR_DELIVERY';
    final date = order.createdAt != null
        ? DateFormat('hh:mm a').format(DateTime.parse(order.createdAt!))
        : 'Unknown Time';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text('Assigned at $date', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    order.status?.replaceAll('_', ' ') ?? 'UNKNOWN',
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, size: 20, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Delivery Address', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(
                        order.deliveryAddress ?? 'No address provided',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${order.orderItemList.length} items',
                      style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  "Collect: ₹${order.paymentMethod == 'COD' ? order.totalAmount.toStringAsFixed(2) : '0.00 (PAID)'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: order.paymentMethod == 'COD' ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: isOutForDelivery
                  ? PrimaryButton(
                      label: 'Complete Delivery',
                      onPressed: () => context.push('/rider/otp-handover/${order.id}'),
                    )
                  : PrimaryButton(
                      label: 'Mark Out For Delivery',
                      isOutlined: true,
                      onPressed: () {},
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

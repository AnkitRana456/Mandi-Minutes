import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../domain/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.cart;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          if (cart != null && cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.error),
              onPressed: () => _confirmClearCart(context, ref),
            ),
        ],
      ),
      body: cartState.isLoading && cart == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : cart == null || cart.items.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartList(context, ref, cart),
      bottomNavigationBar: cart != null && cart.items.isNotEmpty
          ? _buildCheckoutBar(context, cart)
          : null,
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
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
              Icons.shopping_basket_outlined,
              size: 80,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Looks like you haven\'t added anything yet.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/customer/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
            ),
            child: const Text('Start Shopping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, WidgetRef ref, cart) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(cartProvider.notifier).fetchCart(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: cart.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = cart.items[index];
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.shimmerBase,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? 'Unknown Product',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.unit ?? "1 pc"}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${item.unitPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${item.subTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (item.quantity > 1) {
                                  ref.read(cartProvider.notifier).updateItem(item.productId!, item.quantity - 1);
                                } else {
                                  ref.read(cartProvider.notifier).removeItem(item.productId!);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Icon(Icons.remove, color: Colors.white, size: 18),
                              ),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () => ref.read(cartProvider.notifier).updateItem(item.productId!, item.quantity + 1),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Icon(Icons.add, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCheckoutBar(BuildContext context, cart) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Bill', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text(
                    '₹${cart.totalCartValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: 'Proceed to Checkout',
                onPressed: () => context.push('/customer/checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearCart(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(cartProvider.notifier).clearCart();
    }
  }
}

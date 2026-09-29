import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../domain/providers/cart_provider.dart';
import '../../domain/providers/order_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _paymentMethod = 'COD';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckout() async {
    if (_formKey.currentState!.validate()) {
      final order = await ref.read(orderProvider.notifier).checkout(
            _addressController.text.trim(),
            _paymentMethod,
          );

      if (order != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully! 🎉'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/customer/home');
      } else if (mounted) {
        final error = ref.read(orderProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Checkout failed. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final orderState = ref.watch(orderProvider);
    final cart = cartState.cart;

    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Your cart is empty.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Secure Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Delivery Address'),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: AppTextField(
                  controller: _addressController,
                  label: 'Full Address (House No, Building, Street)',
                  prefixIcon: const Icon(Icons.location_on, color: AppColors.primaryGreen),
                  validator: (v) => v!.isEmpty ? 'Delivery address is required' : null,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment Method'),
              _buildPaymentOptions(),
              const SizedBox(height: 24),
              _buildSectionTitle('Bill Summary'),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    _buildBillRow('Item Total', '₹${cart.totalCartValue.toStringAsFixed(2)}'),
                    const SizedBox(height: 12),
                    _buildBillRow('Delivery Partner Fee', '₹15.00'),
                    const SizedBox(height: 12),
                    _buildBillRow('Handling Charge', '₹4.00'),
                    const SizedBox(height: 12),
                    _buildBillRow('Delivery Discount', '-₹19.00', color: AppColors.success),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.divider),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Grand Total',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          '₹${cart.totalCartValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
        ),
        child: SafeArea(
          child: PrimaryButton(
            label: 'Place Order • ₹${cart.totalCartValue.toStringAsFixed(2)}',
            isLoading: orderState.isLoading,
            onPressed: _handleCheckout,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        _buildPaymentCard(
          title: 'Cash on Delivery',
          subtitle: 'Pay at your doorstep',
          icon: Icons.money,
          value: 'COD',
        ),
        const SizedBox(height: 12),
        _buildPaymentCard(
          title: 'Pay Online',
          subtitle: 'UPI, Credit/Debit Cards, Wallets',
          icon: Icons.account_balance_wallet,
          value: 'ONLINE',
        ),
      ],
    );
  }

  Widget _buildPaymentCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.05) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen.withValues(alpha: 0.1) : AppColors.shimmerBase,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {Color color = AppColors.text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 14)),
      ],
    );
  }
}

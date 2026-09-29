import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import 'package:mm_frontend/features/rider/domain/providers/rider_provider.dart';

class OtpHandoverScreen extends ConsumerStatefulWidget {
  final int orderId;

  const OtpHandoverScreen({super.key, required this.orderId});

  @override
  ConsumerState<OtpHandoverScreen> createState() => _OtpHandoverScreenState();
}

class _OtpHandoverScreenState extends ConsumerState<OtpHandoverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _phoneController = TextEditingController(text: "918814073730"); // Defaulting to your testing number

  @override
  void dispose() {
    _otpController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _generateOtp() async {
    if (_phoneController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter customer phone number'), behavior: SnackBarBehavior.floating),
        );
       return;
    }
    
    final success = await ref.read(riderProvider.notifier).generateOtp(
          widget.orderId,
          _phoneController.text.trim(),
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to customer\'s WhatsApp!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (mounted) {
      final error = ref.read(riderProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to send OTP'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final success = await ref.read(riderProvider.notifier).verifyOtp(
            widget.orderId,
            _phoneController.text.trim(),
            _otpController.text.trim(),
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delivery successful! 🎉'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop(); // Go back to deliveries list
      } else if (mounted) {
        final error = ref.read(riderProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Invalid OTP'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(riderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user_outlined,
                    size: 80,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Complete Delivery',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              if (!state.isOtpGenerated) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Enter the customer\'s WhatsApp number to send the delivery OTP.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _phoneController,
                        label: 'Customer WhatsApp Number',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Generate WhatsApp OTP',
                        isLoading: state.isLoading,
                        onPressed: _generateOtp,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Ask the customer for the delivery OTP to hand over the order.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _otpController,
                        label: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.password_outlined, color: AppColors.primaryGreen),
                        validator: (v) => v!.isEmpty ? 'Please enter OTP' : null,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Verify & Deliver',
                        isLoading: state.isLoading,
                        onPressed: _verifyOtp,
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

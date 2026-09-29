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
          const SnackBar(content: Text('Please enter customer phone number')),
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
        ),
      );
    } else if (mounted) {
      final error = ref.read(riderProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to send OTP'),
          backgroundColor: AppColors.error,
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
          ),
        );
        context.pop(); // Go back to deliveries list
      } else if (mounted) {
        final error = ref.read(riderProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Invalid OTP'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(riderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Delivery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Complete Delivery',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              if (!state.isOtpGenerated) ...[
                 Text(
                  'Enter the customer\'s WhatsApp number to send the OTP.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _phoneController,
                  label: 'Customer WhatsApp Number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Generate WhatsApp OTP',
                  isLoading: state.isLoading,
                  onPressed: _generateOtp,
                ),
              ] else ...[
                 Text(
                  'Ask the customer for the delivery OTP to hand over the order.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _otpController,
                  label: 'OTP',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.password_outlined),
                  validator: (v) => v!.isEmpty ? 'Please enter OTP' : null,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Verify & Deliver',
                  isLoading: state.isLoading,
                  onPressed: _verifyOtp,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

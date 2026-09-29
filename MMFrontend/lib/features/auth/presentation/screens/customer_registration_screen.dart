import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../data/models/registration_requests.dart';

class CustomerRegistrationScreen extends ConsumerStatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  ConsumerState<CustomerRegistrationScreen> createState() => _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState extends ConsumerState<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final request = CustomerRegisterRequest(
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        defaultAddress: _addressController.text.trim(),
        emergencyContactPhone: _emergencyContactController.text.trim(),
      );

      final success = await ref.read(authProvider.notifier).registerCustomer(request);

      if (!success && mounted) {
        final error = ref.read(authProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Registration failed'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Customer Signup', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 40,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Join us and start ordering fresh groceries',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.textHint),
                  validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'john@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textHint),
                  validator: (v) => v == null || v.isEmpty ? 'Phone number is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter a strong password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                const Text(
                  'Additional Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressController,
                  label: 'Delivery Address',
                  hint: 'House No, Street, City',
                  prefixIcon: const Icon(Icons.home_outlined, color: AppColors.textHint),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _emergencyContactController,
                  label: 'Emergency Contact',
                  hint: 'Alternative phone number (optional)',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.contact_phone_outlined, color: AppColors.textHint),
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  label: 'Sign Up',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

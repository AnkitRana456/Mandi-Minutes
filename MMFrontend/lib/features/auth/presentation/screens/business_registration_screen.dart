import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../data/models/registration_requests.dart';
import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';

class BusinessRegistrationScreen extends ConsumerStatefulWidget {
  const BusinessRegistrationScreen({super.key});

  @override
  ConsumerState<BusinessRegistrationScreen> createState() => _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState extends ConsumerState<BusinessRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _storeIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    _gstinController.dispose();
    _storeIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final request = BusinessRegisterRequest(
        userName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        businessName: _businessNameController.text.trim(),
        gstinNumber: _gstinController.text.trim(),
        assignedStoreId: int.tryParse(_storeIdController.text.trim()) ?? 0,
      );

      final success = await ref.read(authProvider.notifier).registerBusiness(request);

      if (!success && mounted) {
        final error = ref.read(authProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Registration failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Signup'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Register your Store',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _businessNameController,
                label: 'Business Name',
                prefixIcon: const Icon(Icons.store_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _gstinController,
                label: 'GSTIN Number',
                prefixIcon: const Icon(Icons.receipt_long_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _nameController,
                label: 'Owner Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _emailController,
                label: 'Business Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (v) => v!.isEmpty || !v.contains('@') ? 'Valid email required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _storeIdController,
                label: 'Assigned Store ID',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.numbers_outlined),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline),
                validator: (v) => v!.length < 6 ? 'Minimum 6 characters' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Register Business',
                isLoading: authState.isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

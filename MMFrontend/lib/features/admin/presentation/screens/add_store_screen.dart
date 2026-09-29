import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../domain/providers/admin_provider.dart';
import 'package:mm_frontend/features/admin/data/models/admin_models.dart';

class AddStoreScreen extends ConsumerStatefulWidget {
  const AddStoreScreen({super.key});

  @override
  ConsumerState<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends ConsumerState<AddStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleAddStore() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final request = StoreRequest(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        contactNumber: _phoneController.text.trim(),
      );

      final success = await ref.read(adminProvider.notifier).addStore(request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Store added successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(adminProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to add store'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Register Store', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      size: 50,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Store Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _nameController,
                  label: 'Store Name',
                  hint: 'e.g. Fresh Groceries Mart',
                  prefixIcon: const Icon(Icons.store_outlined, color: AppColors.textHint),
                  validator: (v) => v == null || v.isEmpty ? 'Store name is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressController,
                  label: 'Complete Address',
                  hint: 'Street, Sector, City',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.textHint),
                  validator: (v) => v == null || v.isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _phoneController,
                  label: 'Contact Number',
                  hint: '10-digit mobile number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Contact number is required';
                    if (v.length < 10) return 'Enter a valid phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 48),
                PrimaryButton(
                  label: 'Register Partner Store',
                  isLoading: state.isLoading,
                  onPressed: _handleAddStore,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

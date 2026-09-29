import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/shared/widgets/app_text_field.dart';
import 'package:mm_frontend/shared/widgets/primary_button.dart';
import '../../domain/providers/shopkeeper_provider.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _handleAddProduct() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final request = CreateProductRequest(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        stockQuantity: int.tryParse(_stockController.text) ?? 0,
        category: _categoryController.text.trim(),
      );

      final success = await ref.read(shopkeeperProvider.notifier).addProduct(request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else if (mounted) {
        final error = ref.read(shopkeeperProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to add product'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopkeeperProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Product Name',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descController,
                label: 'Description',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _priceController,
                label: 'Price (₹)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _stockController,
                label: 'Initial Stock Quantity',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _categoryController,
                label: 'Category',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Add Product',
                isLoading: state.isLoading,
                onPressed: _handleAddProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

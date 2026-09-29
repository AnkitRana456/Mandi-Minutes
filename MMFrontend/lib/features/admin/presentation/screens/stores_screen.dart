import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mm_frontend/core/theme/app_theme.dart';
import '../../domain/providers/admin_provider.dart';
import 'package:mm_frontend/features/admin/data/models/admin_models.dart';

class StoresScreen extends ConsumerStatefulWidget {
  const StoresScreen({super.key});

  @override
  ConsumerState<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends ConsumerState<StoresScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminProvider.notifier).fetchStores());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Stores', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
      ),
      body: state.isLoading && state.stores.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : state.stores.isEmpty
              ? _buildEmptyState(context)
              : _buildStoresList(context, ref, state.stores),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/add-store'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Store', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.accentYellow.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.store_mall_directory_rounded,
              size: 64,
              color: AppColors.accentYellow.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Stores Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first partner store to get started.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresList(BuildContext context, WidgetRef ref, List<StoreResponse> stores) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () => ref.read(adminProvider.notifier).fetchStores(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: 100),
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final store = stores[index];
          return _StoreCard(store: store);
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final StoreResponse store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Icon(Icons.storefront_rounded, color: AppColors.primaryGreen, size: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name ?? 'Unknown Store',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          store.address ?? 'No address provided',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        store.contactNumber ?? 'No contact',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

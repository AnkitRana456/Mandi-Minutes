import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';
import 'package:mm_frontend/features/customer/domain/providers/catalog_provider.dart';
import 'package:mm_frontend/features/shopkeeper/data/models/shopkeeper_models.dart';
import 'package:mm_frontend/features/customer/presentation/screens/search_screen.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  _buildPromoBanner(ref),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'Shop by Category'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildCategorySection(ref, context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildQuickActions(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'Fresh from the Mandi 🍅'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildProductHorizontalList(ref, 'fresh'),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle(context, 'Daily Essentials 🥛'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildProductHorizontalList(ref, 'daily_essentials'),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryGreen,
      pinned: true,
      expandedHeight: 130,
      collapsedHeight: 65,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        background: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            'Delivery in 10 minutes',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ],
                      ),
                      Text(
                        'Home - Your saved address, City',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        title: _buildSearchBar(context),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textHint, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Search "Fresh Tomatoes"',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(Icons.mic_none, color: AppColors.primaryGreen, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(WidgetRef ref) {
    final promoAsync = ref.watch(promotionsProvider);
    
    return promoAsync.when(
      data: (promotions) {
        if (promotions.isEmpty) return const SizedBox.shrink();
        final promo = promotions.first; // show the first one
        return Container(
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.accentYellow.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.accentYellow),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        promo.title,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo.subtitle,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.local_offer,
                  size: 80,
                  color: AppColors.primaryGreen.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'See all',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(WidgetRef ref, BuildContext context) {
    final catAsync = ref.watch(categoriesProvider);

    return SizedBox(
      height: 100,
      child: catAsync.when(
        data: (categories) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Column(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Center(
                        child: Text(
                          cat.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading categories')),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard('Super Savings', Icons.percent, Colors.orange),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildActionCard('Reorder', Icons.receipt_long, Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHorizontalList(WidgetRef ref, String sectionId) {
    final productsAsync = ref.watch(featuredProductsProvider(sectionId));

    return SizedBox(
      height: 220,
      child: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppRadius.md),
                          ),
                        ),
                        child: Center(
                          child: product.imageUrl != null
                              ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                              : Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: AppColors.textHint.withValues(alpha: 0.5),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.unit ?? '1 item',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${product.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 28,
                                width: 60,
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Implementation for adding to cart
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor: AppColors.primaryGreen,
                                    side: const BorderSide(color: AppColors.primaryGreen),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppRadius.sm),
                                    ),
                                  ),
                                  child: const Text('ADD', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading products')),
      ),
    );
  }
}

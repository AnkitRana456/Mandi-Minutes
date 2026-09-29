import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Join Mandi Minutes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.lg),
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
                    Icons.store_mall_directory_rounded,
                    size: 40,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'How would you like to join?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select your account type to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _RoleCard(
                title: 'Customer',
                description: 'Order fresh groceries and daily essentials in minutes.',
                icon: Icons.shopping_basket_rounded,
                color: AppColors.primaryGreen,
                onTap: () => context.push('/signup/customer'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Business Partner',
                description: 'Register your store and sell products online.',
                icon: Icons.storefront_rounded,
                color: AppColors.warning,
                onTap: () => context.push('/signup/business'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Delivery Rider',
                description: 'Join our fleet and earn money by delivering orders.',
                icon: Icons.electric_moped_rounded,
                color: Colors.blue,
                onTap: () => context.push('/signup/rider'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Admin',
                description: 'Manage users, stores, and overall platform operations.',
                icon: Icons.admin_panel_settings_rounded,
                color: AppColors.error,
                onTap: () => context.push('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          highlightColor: color.withValues(alpha: 0.05),
          splashColor: color.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

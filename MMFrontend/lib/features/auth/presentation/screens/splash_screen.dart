import 'package:mm_frontend/features/auth/domain/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_frontend/core/theme/app_theme.dart';


class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to auth state to trigger redirect
    ref.listen(authProvider, (previous, next) {
      if (next.status != AuthStatus.initial) {
        // Router will handle redirect based on state
        context.go('/login'); // Trigger router evaluation
      }
    });

    return const Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_basket_rounded,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Mandi Minutes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}


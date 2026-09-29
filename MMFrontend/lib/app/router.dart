import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/domain/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/auth/presentation/screens/customer_registration_screen.dart';
import '../features/auth/presentation/screens/business_registration_screen.dart';
import '../features/auth/presentation/screens/rider_registration_screen.dart';
import '../features/customer/presentation/screens/customer_main_screen.dart';
import '../features/customer/presentation/screens/checkout_screen.dart';
import '../features/shopkeeper/presentation/screens/shopkeeper_main_screen.dart';
import '../features/shopkeeper/presentation/screens/add_product_screen.dart';
import '../features/admin/presentation/screens/admin_main_screen.dart';
import '../features/admin/presentation/screens/add_store_screen.dart';
import '../features/rider/presentation/screens/rider_main_screen.dart';
import '../features/rider/presentation/screens/otp_handover_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';
      final isSigningUp = state.matchedLocation.startsWith('/signup');
      
      if (authState.status == AuthStatus.initial) {
        return isSplash ? null : '/'; // Force splash while loading
      }

      if (authState.status == AuthStatus.unauthenticated && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      if (authState.status == AuthStatus.authenticated) {
        if (isLoggingIn || isSplash) {
          // Role-based redirection
          switch (authState.user?.role) {
            case 'CUSTOMER':
              return '/customer/home';
            case 'BUSINESS':
              return '/shopkeeper/dashboard';
            case 'RIDER':
              return '/rider/dashboard';
            case 'ADMIN':
              return '/admin/dashboard';
            default:
              return '/customer/home'; // Default fallback
          }
        }
      }

      return null; // No redirect needed
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/signup/customer',
        builder: (context, state) => const CustomerRegistrationScreen(),
      ),
      GoRoute(
        path: '/signup/business',
        builder: (context, state) => const BusinessRegistrationScreen(),
      ),
      GoRoute(
        path: '/signup/rider',
        builder: (context, state) => const RiderRegistrationScreen(),
      ),
      // Customer Routes
      GoRoute(
        path: '/customer/home',
        builder: (context, state) => const CustomerMainScreen(),
      ),
      GoRoute(
        path: '/customer/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      // Shopkeeper Routes
      GoRoute(
        path: '/shopkeeper/dashboard',
        builder: (context, state) => const ShopkeeperMainScreen(),
      ),
      GoRoute(
        path: '/shopkeeper/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
      // Rider Routes
      GoRoute(
        path: '/rider/dashboard',
        builder: (context, state) => const RiderMainScreen(),
      ),
      GoRoute(
        path: '/rider/otp-handover/:orderId',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return OtpHandoverScreen(orderId: orderId);
        },
      ),
      // Admin Routes
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminMainScreen(),
      ),
      GoRoute(
        path: '/admin/add-store',
        builder: (context, state) => const AddStoreScreen(),
      ),
    ],
  );
});

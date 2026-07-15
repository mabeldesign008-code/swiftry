import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../screens/welcome_screen.dart';
import '../../screens/onboarding_screen.dart';
import '../../screens/get_started_screen.dart';
import '../../screens/home_screen_v2.dart';
import '../../screens/search_screen.dart';
import '../../screens/orders_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/order_tracking_screen.dart';
import '../../screens/checkout_screen.dart';
import '../../models/service_type.dart';
import '../../models/order.dart';
import '../config/env.dart';

/// Centralized GoRouter configuration - frontend ready for backend auth guard.
/// Uses Material 3 page transitions, preserves old MaterialPageRoute for gradual migration.

class AppRoutes {
  AppRoutes._();
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String getStarted = '/get-started';
  static const String home = '/home';
  static const String search = '/search';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String orderTracking = '/orders/:id/tracking';
  static const String checkout = '/checkout';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String notifications = '/notifications';
  static const String wallet = '/wallet';
  static const String vendorStore = '/vendor/:id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch auth state if needed future
  // final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: Env.isDevelopment,
    // TODO Backend: Add redirect logic for auth guard when token check is real
    redirect: (context, state) {
      // Example auth guard (currently disabled - allows all):
      // final isLoggedIn = secureStorage.isLoggedIn() sync version or via provider
      // final isAuthRoute = state.matchedLocation.startsWith('/welcome') || 
      //                     state.matchedLocation.startsWith('/login') ||
      //                     state.matchedLocation.startsWith('/onboarding');
      // if (!isLoggedIn && !isAuthRoute) return AppRoutes.welcome;
      // if (isLoggedIn && isAuthRoute) return AppRoutes.home;
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.matchedLocation}'),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.getStarted,
        name: 'get-started',
        builder: (context, state) => const GetStartedScreen(),
      ),
      // Main shell with bottom nav (future: StatefulShellRoute)
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreenV2(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // Dynamic routes with params
      // Note: orderTracking requires service type - we pass via extra now, path param for id
      GoRoute(
        path: '/orders/:id/tracking',
        name: 'order-tracking',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          // extra can hold Order object or ServiceType
          final extra = state.extra as Map<String, dynamic>?;
          final serviceType = extra?['serviceType'] as ServiceType? ?? ServiceType.food;
          return OrderTrackingScreen(
            orderId: orderId,
            serviceType: serviceType,
          );
        },
      ),
      // TODO Backend: Add more routes as screens are migrated:
      // vendor store, checkout, notifications, wallet, etc.
      // Keeping old MaterialPageRoute pushes working for now to avoid breaking.
    ],
  );
});

/// Helper to generate deep links for sharing
class DeepLinkHelper {
  static String vendorLink(String vendorId) => 'https://swiftree.com/vendor/$vendorId';
  static String orderLink(String orderId) => 'https://swiftree.com/orders/$orderId';
  static String productLink(String productId) => 'https://swiftree.com/product/$productId';
}

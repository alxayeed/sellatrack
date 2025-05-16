import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/update_profile_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/customer_list_screen.dart';

import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/sales/presentation/screens/sale_list_screen.dart';
import 'router_listenable.dart';

class AppRoutePaths {
  static const String splash = '/';
  static const String authentication = '/auth';
  static const String profileCompletion = '/complete-profile';
  static const String profile = '/profile';
  static const String updateProfileSubPath = 'edit';
  static const String updateProfileNamed = 'update-profile';
  static const String sales = '/sales';
  static const String customers = '/customers';
  static const String addCustomer = '/customers/add';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerListener = ref.watch(routerListenableProvider);

  return GoRouter(
    initialLocation: AppRoutePaths.splash,
    // Always start at splash
    debugLogDiagnostics: true,
    refreshListenable: routerListener,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.splash,
        builder:
            (context, state) => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
      ),
      GoRoute(
        path: AppRoutePaths.authentication,
        builder: (BuildContext context, GoRouterState state) {
          return const AuthenticationScreen();
        },
      ),
      GoRoute(
        path: AppRoutePaths.profileCompletion,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileCompletionScreen();
        },
      ),
      GoRoute(
        path: AppRoutePaths.profile,
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.updateProfileSubPath,
            name: AppRoutePaths.updateProfileNamed,
            builder: (BuildContext context, GoRouterState state) {
              return const UpdateProfileScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.sales,
        builder: (BuildContext context, GoRouterState state) {
          return const SaleListScreen();
        },
      ),
      GoRoute(
        path: AppRoutePaths.customers,
        builder: (BuildContext context, GoRouterState state) {
          return const CustomerListScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'add',
            name: AppRoutePaths.addCustomer,
            builder: (BuildContext context, GoRouterState state) {
              return const AddCustomerScreen();
            },
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool isInitialized = routerListener.initialAuthCheckDone;
      final bool isLoggedIn = routerListener.isLoggedIn;
      final String intendedLocation = state.matchedLocation;

      // If not initialized yet, stay on splash.
      if (!isInitialized) {
        return (intendedLocation == AppRoutePaths.splash)
            ? null
            : AppRoutePaths.splash;
      }

      // If initialized and logged in:
      if (isLoggedIn) {
        // If they are trying to go to auth screen, or are on splash, redirect to sales.
        if (intendedLocation == AppRoutePaths.authentication ||
            intendedLocation == AppRoutePaths.splash) {
          return AppRoutePaths.sales;
        }
        // Otherwise, let them go where they intended (e.g., /sales, /profile, /customers)
        return null;
      }
      // If initialized and NOT logged in:
      else {
        // If they are not already on the auth screen or splash, redirect to auth.
        if (intendedLocation != AppRoutePaths.authentication &&
            intendedLocation != AppRoutePaths.splash) {
          return AppRoutePaths.authentication;
        }
        // Otherwise, let them stay on auth or splash
        return null;
      }
    },
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/update_profile_screen.dart';

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
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerListener = ref.watch(routerListenableProvider);

  return GoRouter(
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    // refreshListenable: routerListener,
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
    ],
    redirect: (BuildContext context, GoRouterState state) {
      if (!routerListener.initialCheckDone) {
        return AppRoutePaths.splash;
      }

      final bool isLoggedIn = routerListener.isLoggedIn;
      final bool isProfileComplete = routerListener.isProfileComplete;
      final String currentLocation = state.matchedLocation;

      final bool isOnAuthScreen =
          currentLocation == AppRoutePaths.authentication;
      final bool isOnProfileCompletion =
          currentLocation == AppRoutePaths.profileCompletion;
      final bool isOnSplash = currentLocation == AppRoutePaths.splash;

      if (!isLoggedIn) {
        // if (isOnAuthScreen || isOnSplash) {
        //   return null;
        // }
        return AppRoutePaths.authentication;
      } else {
        if (!isProfileComplete) {
          if (isOnProfileCompletion || isOnAuthScreen || isOnSplash) {
            return null;
          }
          return AppRoutePaths.profileCompletion;
        } else {
          if (currentLocation == AppRoutePaths.profile) {
            return AppRoutePaths.profile;
          }
          return AppRoutePaths.sales;
        }
      }
      return null;
    },
  );
});

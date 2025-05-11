import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/update_profile_screen.dart';

import 'router_listenable.dart'; // Import the new listenable

class AppRoutePaths {
  static const String authentication = '/auth';
  static const String otp = '/otp';
  static const String profileCompletion = '/complete-profile';
  static const String profile = '/profile';
  static const String updateProfileSubPath = 'edit';
  static const String updateProfileNamed = 'update-profile';
  static const String splash = '/'; // Add a splash/loading route
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Provide the GoRouter
  final routerRefreshListenable = ref.watch(routerListenableProvider);

  return GoRouter(
    initialLocation: AppRoutePaths.splash,
    // Start at a splash/loading screen
    debugLogDiagnostics: true,
    refreshListenable: routerRefreshListenable,
    // Key for reactive redirects
    routes: <RouteBase>[
      GoRoute(
        // A simple splash/loading screen
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
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool isLoggedIn = routerRefreshListenable.isLoggedIn;
      final bool isProfileConsideredComplete =
          routerRefreshListenable.isProfileComplete;

      final String currentLocation = state.matchedLocation;
      final bool isAtSplash = currentLocation == AppRoutePaths.splash;
      final bool isOnAuthFlow =
          currentLocation == AppRoutePaths.authentication ||
          currentLocation == AppRoutePaths.otp;
      final bool isOnProfileCompletion =
          currentLocation == AppRoutePaths.profileCompletion;

      if (isAtSplash && !isLoggedIn) return AppRoutePaths.authentication;
      if (isAtSplash && isLoggedIn && !isProfileConsideredComplete) {
        return AppRoutePaths.profileCompletion;
      }
      if (isAtSplash && isLoggedIn && isProfileConsideredComplete) {
        return AppRoutePaths.profile;
      }

      if (!isLoggedIn && !isOnAuthFlow) {
        return AppRoutePaths.authentication;
      }

      if (isLoggedIn) {
        if (!isProfileConsideredComplete &&
            !isOnProfileCompletion &&
            !isOnAuthFlow) {
          // If profile not complete, but user tries to go somewhere else (not auth or completion), send to completion.
          // Exception: if user is in OTP flow (part of auth) or already on completion, let them be.
          return AppRoutePaths.profileCompletion;
        }
        if (isProfileConsideredComplete &&
            (isOnAuthFlow || isOnProfileCompletion)) {
          // If profile is complete and user is on auth/otp/completion, send to profile.
          return AppRoutePaths.profile;
        }
      }
      return null;
    },
  );
});

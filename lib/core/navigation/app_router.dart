import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/otp_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/update_profile_screen.dart';

class AppRoutePaths {
  static const String authentication = '/auth';
  static const String otp = '/otp';
  static const String profileCompletion = '/complete-profile';
  static const String profile = '/profile';
  static const String updateProfileSubPath = 'edit';
  static const String updateProfileNamed = 'update-profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePaths.authentication,
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePaths.authentication,
      builder: (BuildContext context, GoRouterState state) {
        return const AuthenticationScreen();
      },
    ),
    GoRoute(
      path: AppRoutePaths.otp,
      builder: (BuildContext context, GoRouterState state) {
        return const OtpScreen();
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
    return null;
  },
);

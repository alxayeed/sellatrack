import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/update_profile_screen.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/presentation/screens/add_customer_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/customer_detail_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/customer_list_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/edit_customer_screen.dart'; // Import EditCustomerScreen

import '../../features/sales/presentation/screens/sale_list_screen.dart';
import '../widgets/screens/splash_screen.dart';
import '../widgets/screens/widget_library_screen.dart';
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
  static const String addCustomer = 'add';
  static const String customerDetail = 'detail/:customerId';
  static const String customerDetailNamed = 'customer-detail';
  static const String editCustomer =
      'edit/:customerId'; // Path for editing a specific customer
  static const String editCustomerNamed = 'edit-customer';

  static const String widgetLibrary = '/widget-library';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  ref.watch(routerListenableProvider);

  return GoRouter(
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    // refreshListenable: routerListener,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
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
            path: AppRoutePaths.addCustomer,
            name: AppRoutePaths.addCustomer,
            builder: (BuildContext context, GoRouterState state) {
              return const AddCustomerScreen();
            },
          ),
          GoRoute(
            path: AppRoutePaths.customerDetail,
            name: AppRoutePaths.customerDetailNamed,
            builder: (BuildContext context, GoRouterState state) {
              final customer = state.extra as CustomerEntity?;
              if (customer != null) {
                return CustomerDetailScreen(customer: customer);
              }
              return const Scaffold(
                body: Center(child: Text('Customer not found')),
              );
            },
            routes: <RouteBase>[
              // Edit as a sub-route of detail
              GoRoute(
                path: AppRoutePaths.updateProfileSubPath, // 'edit'
                name: AppRoutePaths.editCustomerNamed, // 'edit-customer'
                builder: (BuildContext context, GoRouterState state) {
                  final customerToEdit = state.extra as CustomerEntity?;
                  if (customerToEdit != null) {
                    return EditCustomerScreen(customerToEdit: customerToEdit);
                  }
                  return const Scaffold(
                    body: Center(
                      child: Text('Customer to edit not found via extra.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutePaths.widgetLibrary,
        builder: (context, state) => const WidgetLibraryScreen(),
      ),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   final bool isInitialized = routerListener.initialAuthCheckDone;
    //   final bool isLoggedIn = routerListener.isLoggedIn;
    //   final String intendedLocation = state.matchedLocation;
    //
    //   // If initialized and logged in:
    //   if (isLoggedIn) {
    //     // If they are trying to go to auth screen, or are on splash, redirect to sales.
    //     if (intendedLocation == AppRoutePaths.authentication ||
    //         intendedLocation == AppRoutePaths.splash) {
    //       return AppRoutePaths.sales;
    //     }
    //     // Otherwise, let them go where they intended (e.g., /sales, /profile, /customers)
    //     return null;
    //   }
    //   // If initialized and NOT logged in:
    //   else {
    //     // If they are not already on the auth screen or splash, redirect to auth.
    //     if (intendedLocation != AppRoutePaths.authentication &&
    //         intendedLocation != AppRoutePaths.splash) {
    //       return AppRoutePaths.authentication;
    //     }
    //     // Otherwise, let them stay on auth or splash
    //     return null;
    //   }
    // },
  );
});

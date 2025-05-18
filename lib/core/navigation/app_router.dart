import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/customer_list_screen.dart';

import '../../features/customers/domain/entities/customer_entity.dart';
import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/customers/presentation/screens/edit_customer_screen.dart';
import '../../features/sales/presentation/screens/sale_list_screen.dart';
import '../common/common.dart';
import 'router_listenable.dart';

class StocksScreen extends StatelessWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(child: Text('Stocks Screen - Coming Soon!')),
    );
  }
}

class AppRoutePaths {
  static const String splash = '/';
  static const String authentication = '/auth';
  static const String home = '/home';
  static const String profileCompletion = '/complete-profile';
  static const String widgetLibrary = '/dev/widget-library';

  static const String sales = '/sales';
  static const String stocks = '/stocks';
  static const String customers = '/customers';
  static const String profile = '/profile';

  static const String updateAuthProfileSubPath = 'edit-auth-profile';
  static const String updateAuthProfileNamed = 'update-auth-profile';

  static const String addCustomer = 'add';
  static const String customerDetail = 'detail/:customerId';
  static const String customerDetailNamed = 'customer-detail';
  static const String editCustomerSubPath = 'edit';
  static const String editCustomerNamed = 'edit-customer-profile';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerListener = ref.watch(routerListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: routerListener,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.widgetLibrary,
        builder: (context, state) => const WidgetLibraryScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.authentication,
        builder: (context, state) => const AuthenticationScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.profileCompletion,
        builder: (context, state) => const ProfileCompletionScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutePaths.customers,
        builder: (context, state) => const CustomerListScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.addCustomer,
            name: 'customers_add_customer',
            builder: (context, state) => const AddCustomerScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.customerDetail,
            name: AppRoutePaths.customerDetailNamed,
            builder: (context, state) {
              final customer = state.extra;
              if (customer is CustomerEntity) {
                return CustomerDetailScreen(customer: customer);
              }
              return const Scaffold(
                body: Center(child: Text('Customer not found')),
              );
            },
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutePaths.editCustomerSubPath,
                name: AppRoutePaths.editCustomerNamed,
                builder: (context, state) {
                  final customerToEdit = state.extra;
                  if (customerToEdit is CustomerEntity) {
                    return EditCustomerScreen(customerToEdit: customerToEdit);
                  }
                  return const Scaffold(
                    body: Center(child: Text('Customer to edit not found.')),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Shell route for main sections with shared layout
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.sales,
            builder: (context, state) => const SaleListScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.stocks,
            builder: (context, state) => const StocksScreen(),
          ),
        ],
      ),
    ],

    // Redirect logic: Uncomment and configure as needed
    // redirect: (BuildContext context, GoRouterState state) {
    //   if (!routerListener.initialCheckDone) {
    //     return AppRoutePaths.splash;
    //   }
    //
    //   final bool isLoggedIn = routerListener.isLoggedIn;
    //   final bool isProfileComplete = routerListener.isProfileComplete;
    //   final String intendedPath = state.uri.toString();
    //
    //   final authFlowPaths = [
    //     AppRoutePaths.splash,
    //     AppRoutePaths.authentication,
    //     AppRoutePaths.profileCompletion,
    //   ];
    //   final bool isOnAuthFlowPath =
    //       authFlowPaths.contains(intendedPath.split('?').first);
    //
    //   if (!isLoggedIn) {
    //     return isOnAuthFlowPath ? null : AppRoutePaths.authentication;
    //   }
    //
    //   if (!isProfileComplete) {
    //     return intendedPath == AppRoutePaths.profileCompletion ||
    //             intendedPath == AppRoutePaths.authentication ||
    //             intendedPath == AppRoutePaths.splash
    //         ? null
    //         : AppRoutePaths.profileCompletion;
    //   }
    //
    //   if (isOnAuthFlowPath) {
    //     return AppRoutePaths.sales;
    //   }
    //
    //   return null;
    // },
  );
});

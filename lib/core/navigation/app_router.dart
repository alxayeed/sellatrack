import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/features/auth/presentation/screens/authentication_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_completion_screen.dart';
import 'package:sellatrack/features/auth/presentation/screens/profile_screen.dart';
import 'package:sellatrack/features/customers/presentation/screens/customer_list_screen.dart';
import 'package:sellatrack/features/sales/presentation/screens/add_edit_sale_screen.dart';

import '../../features/customers/domain/entities/customer_entity.dart';
import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/customers/presentation/screens/edit_customer_screen.dart';
import '../../features/sales/domain/entities/sale_entity.dart';
import '../../features/sales/presentation/screens/sale_detail_screen.dart';
import '../../features/sales/presentation/screens/sale_list_screen.dart';
import '../common/common.dart';
import '../common/screens/stocks_screen.dart';
import '../navigation/router_listenable.dart';

class AppRoutePaths {
  static const String splash = '/';
  static const String authentication = '/auth';
  static const String home = '/home';
  static const String profileCompletion = '/complete-profile';
  static const String widgetLibrary = '/dev/widget-library';

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

  // Sales routes
  static const String sales = '/sales';
  static const String addSaleNamed = 'add';
  static const String saleDetail = 'detail';
  static const String saleDetailNamed = 'sale-detail';
  static const String editSaleSubPath = 'edit';
  static const String editSaleNamed = 'edit-sale';
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
      // Routes outside the shell (no MainScreen scaffold)
      GoRoute(
        path: AppRoutePaths.splash,
        builder: (context, state) => const AuthenticationScreen(),
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

      // Shell route wrapping main sections with MainScreen scaffold
      ShellRoute(
        builder: (context, state, child) {
          // Use fullPath or location string for MainScreen to determine UI
          final location = state.fullPath ?? state.uri.toString();
          return MainScreen(location: location, child: child);
        },
        routes: [
          // Sales main screen + nested sales routes
          GoRoute(
            path: AppRoutePaths.sales,
            builder: (context, state) => const SalesListScreen(),
            routes: [
              GoRoute(
                path: AppRoutePaths.addSaleNamed, // 'add'
                name: AppRoutePaths.addSaleNamed,
                builder: (context, state) => const AddEditSaleScreen(),
              ),
              GoRoute(
                path: AppRoutePaths.saleDetail,
                name: AppRoutePaths.saleDetailNamed,
                builder: (context, state) {
                  final sale = state.extra;
                  if (sale is! SaleEntity) {
                    return const Scaffold(
                      body: Center(child: Text('Sale not found or invalid')),
                    );
                  }
                  return SaleDetailScreen(sale: sale);
                },
                routes: [
                  GoRoute(
                    path: AppRoutePaths.editSaleSubPath, // 'edit'
                    name: AppRoutePaths.editSaleNamed,
                    builder: (context, state) {
                      final saleToEdit = state.extra;
                      if (saleToEdit is! SaleEntity) {
                        return const Scaffold(
                          body: Center(child: Text('Sale to edit not found')),
                        );
                      }
                      return AddEditSaleScreen(sale: saleToEdit);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Customers main screen + nested routes
          GoRoute(
            path: AppRoutePaths.customers,
            builder: (context, state) => const CustomerListScreen(),
            routes: [
              GoRoute(
                path: AppRoutePaths.addCustomer, // 'add'
                name: 'customers_add_customer',
                builder: (context, state) => const AddCustomerScreen(),
              ),
              GoRoute(
                path: AppRoutePaths.customerDetail, // 'detail/:customerId'
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
                routes: [
                  GoRoute(
                    path: AppRoutePaths.editCustomerSubPath, // 'edit'
                    name: AppRoutePaths.editCustomerNamed,
                    builder: (context, state) {
                      final customerToEdit = state.extra;
                      if (customerToEdit is CustomerEntity) {
                        return EditCustomerScreen(
                          customerToEdit: customerToEdit,
                        );
                      }
                      return const Scaffold(
                        body: Center(
                          child: Text('Customer to edit not found.'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Stocks screen
          GoRoute(
            path: AppRoutePaths.stocks,
            builder: (context, state) => const StocksScreen(),
          ),

          // Home screen
          GoRoute(
            path: AppRoutePaths.home,
            builder: (context, state) => const HomeScreen(),
          ),
        ],
      ),
    ],

    // Uncomment and adapt your redirect logic here if needed
    // redirect: (BuildContext context, GoRouterState state) {
    //   ...
    // },
  );
});

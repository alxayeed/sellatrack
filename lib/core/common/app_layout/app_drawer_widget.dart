import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/auth/presentation/providers/auth_providers.dart';

import '../../di/providers.dart'; // For sign out
// Import AppStrings if you have it
// import 'package:sellatrack/core/constants/app_strings.dart';

class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDev = ref.read(appConfigProvider).isDev;
    final theme = Theme.of(context);
    final currentUser =
        ref
            .watch(authNotifierProvider)
            .user; // Watch the whole state to get user

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              currentUser?.displayName ?? 'SellaTrack User',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              currentUser?.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              foregroundColor: theme.colorScheme.primary,
              backgroundImage:
                  currentUser?.photoURL != null &&
                          currentUser!.photoURL!.isNotEmpty
                      ? NetworkImage(currentUser.photoURL!)
                      : null,
              child:
                  (currentUser?.photoURL == null ||
                              currentUser!.photoURL!.isEmpty) &&
                          currentUser?.displayName?.isNotEmpty == true
                      ? Text(
                        currentUser!.displayName![0].toUpperCase(),
                        style: theme.textTheme.headlineMedium,
                      )
                      : ((currentUser?.photoURL == null ||
                              currentUser!.photoURL!.isEmpty)
                          ? const Icon(Icons.person, size: 36)
                          : null),
            ),
            decoration: BoxDecoration(color: theme.colorScheme.primary),
          ),
          ListTile(
            leading: const Icon(Icons.point_of_sale_outlined),
            title: const Text('Sales'), // Use AppStrings.salesTitle
            onTap: () {
              Navigator.pop(context); // Close the drawer
              context.push(AppRoutePaths.sales);
              context.push(AppRoutePaths.sales);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Stocks'), // Use AppStrings.stocksTitle
            onTap: () {
              Navigator.pop(context);
              // TODO: context.go(AppRoutePaths.stocks);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stocks - Coming Soon!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: const Text('Customers'), // Use AppStrings.customersTitle
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutePaths.customers);
            },
          ),
          const Divider(),
          isDev
              ? ListTile(
                leading: const Icon(Icons.widgets),
                title: const Text('Widget Library'),
                // Use AppStrings.myProfileTitle
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutePaths.widgetLibrary);
                },
              )
              : SizedBox(),

          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('My Profile'), // Use AppStrings.myProfileTitle
            onTap: () {
              Navigator.pop(context);
              context.push(AppRoutePaths.profile);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'), // Use AppStrings.settingsTitle
            onTap: () {
              Navigator.pop(context);
              // TODO: context.go(AppRoutePaths.settings);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings - Coming Soon!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text(
              'Sign Out',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            // Use AppStrings.signOut
            onTap: () {
              ref.read(authNotifierProvider.notifier).signOut();
              context.go(AppRoutePaths.authentication);
            },
          ),
        ],
      ),
    );
  }
}

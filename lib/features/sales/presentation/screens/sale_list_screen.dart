import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';

class SaleListScreen extends ConsumerWidget {
  const SaleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('SellaTrack Home'), // Changed title slightly
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'My Profile',
            onPressed: () {
              context.push(AppRoutePaths.profile);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          // Added SingleChildScrollView for smaller screens
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.storefront_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to SellaTrack!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your sales, expenses, and customers.', // Updated text
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text('Record New Sale'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  // Give buttons some min width
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: theme.textTheme.titleMedium,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add New Sale - Coming Soon!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('Record New Expense'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: theme.textTheme.titleMedium,
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add New Expense - Coming Soon!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16), // Spacing for the new button
              TextButton.icon(
                // Using TextButton for a less prominent look for now
                icon: const Icon(Icons.people_alt_outlined),
                label: const Text('View Customers'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: theme.textTheme.titleMedium,
                  foregroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  context.push(
                    AppRoutePaths.customers,
                  ); // Navigate to CustomerListScreen
                },
              ),

              TextButton.icon(
                // Using TextButton for a less prominent look for now
                icon: const Icon(Icons.people_alt_outlined),
                label: const Text('Widget Library'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(200, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: theme.textTheme.titleMedium,
                  foregroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  context.push(
                    AppRoutePaths.widgetLibrary,
                  ); // Navigate to CustomerListScreen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

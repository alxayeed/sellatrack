import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/widgets/empty_list_widget.dart';
import 'package:sellatrack/core/widgets/error_display_widget.dart';
import 'package:sellatrack/core/widgets/loading_indicator_widget.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_notifier.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';
import 'package:sellatrack/features/customers/presentation/providers/customer_providers.dart';
import 'package:sellatrack/features/customers/presentation/widgets/customer_list_item_widget.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch customers when the screen is first initialized
    Future.microtask(
      () => ref.read(customerListNotifierProvider.notifier).fetchCustomers(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref
        .read(customerListNotifierProvider.notifier)
        .fetchCustomers(searchQuery: query);
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerListNotifierProvider);
    final customerNotifier = ref.read(customerListNotifierProvider.notifier);
    final theme = Theme.of(context);

    // Listen for errors to show SnackBar (optional, if ErrorDisplayWidget isn't enough)
    ref.listen<CustomerListState>(customerListNotifierProvider, (
      previous,
      next,
    ) {
      if (next.status == CustomerListStatus.error &&
          next.errorMessage != null &&
          (previous?.errorMessage != next.errorMessage ||
              previous?.status != next.status)) {
        AppSnackBar.showError(context, message: next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        centerTitle: true,
        // Optional: Add search functionality later
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(kToolbarHeight),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //     child: TextField(
        //       controller: _searchController,
        //       decoration: InputDecoration(
        //         hintText: 'Search customers...',
        //         prefixIcon: Icon(Icons.search),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(8.0),
        //           borderSide: BorderSide.none,
        //         ),
        //         filled: true,
        //         contentPadding: EdgeInsets.symmetric(vertical: 0),
        //       ),
        //       onChanged: _onSearchChanged, // Or use a debounce
        //     ),
        //   ),
        // ),
      ),
      body: RefreshIndicator(
        onRefresh:
            () => customerNotifier.fetchCustomers(
              searchQuery: _searchController.text,
            ),
        child: _buildBody(context, customerState, customerNotifier),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutePaths.addCustomer);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Customer - Coming Soon!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CustomerListState customerState,
    CustomerListNotifier customerNotifier,
  ) {
    switch (customerState.status) {
      case CustomerListStatus.initial:
      case CustomerListStatus.loading:
        return const LoadingIndicatorWidget(message: 'Loading customers...');
      case CustomerListStatus.error:
        return ErrorDisplayWidget(
          errorMessage:
              customerState.errorMessage ?? 'Failed to load customers.',
          onRetry:
              () => customerNotifier.fetchCustomers(
                searchQuery: _searchController.text,
              ),
        );
      case CustomerListStatus.empty:
        return EmptyListWidget(
          message: 'No customers found.',
          icon: Icons.people_outline_rounded,
          onRetry: () => customerNotifier.fetchCustomers(), // Retry fetching
          retryButtonText: 'Refresh List',
        );
      case CustomerListStatus.success:
        if (customerState.customers.isEmpty &&
            _searchController.text.isNotEmpty) {
          return EmptyListWidget(
            message:
                'No customers match your search for "${_searchController.text}".',
            icon: Icons.search_off_rounded,
          );
        }
        return ListView.builder(
          itemCount: customerState.customers.length,
          itemBuilder: (context, index) {
            final customer = customerState.customers[index];
            return CustomerListItemWidget(
              customer: customer,
              onTap: () {
                context.push(
                  '${AppRoutePaths.customers}/detail/${customer.id}',
                  extra: customer,
                );
              },
              // onDelete: () => customerNotifier.deleteCustomer(customer.id), // Example
            );
          },
        );
    }
  }
}

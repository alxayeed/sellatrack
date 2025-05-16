import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

class CustomerDetailScreen extends ConsumerWidget {
  final CustomerEntity customer;

  const CustomerDetailScreen({super.key, required this.customer});

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String? displayValue,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 2),
                Text(displayValue ?? 'N/A', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.onSecondaryContainer),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final DateFormat dateFormat = DateFormat.yMMMd();
    final DateFormat dateTimeFormat = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Customer',
            onPressed: () {
              // Navigate to EditCustomerScreen, passing the customer object
              // We defined 'edit' as a sub-route of customer detail in app_router
              // context.goNamed(AppRoutePaths.editCustomerNamed, extra: customer);
              // Or, if using the path directly and editCustomer is a sub-route of customerDetail
              context.go(
                '${AppRoutePaths.customers}/${AppRoutePaths.customerDetail.split('/:').first}/${customer.id}/${AppRoutePaths.updateProfileSubPath}', // Assumes 'edit' is the subpath
                extra: customer,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      customer.photoUrl != null && customer.photoUrl!.isNotEmpty
                          ? NetworkImage(customer.photoUrl!)
                          : null,
                  child:
                      (customer.photoUrl == null || customer.photoUrl!.isEmpty)
                          ? Text(
                            customer.name.isNotEmpty
                                ? customer.name[0].toUpperCase()
                                : 'C',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          )
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  customer.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (customer.email != null && customer.email!.isNotEmpty)
                  Text(
                    customer.email!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          _buildDetailRow(
            context,
            Icons.phone_outlined,
            'Contact Number',
            customer.phoneNumber,
          ),
          _buildDetailRow(
            context,
            Icons.location_on_outlined,
            'Address',
            customer.address,
          ),
          if (customer.notes != null && customer.notes!.isNotEmpty)
            _buildDetailRow(
              context,
              Icons.note_alt_outlined,
              'Notes',
              customer.notes,
            ),
          const SizedBox(height: 16),
          const Text(
            'Purchase History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatsCard(
                  context,
                  'Total Orders',
                  customer.totalOrders.toString(),
                  Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatsCard(
                  context,
                  'Total Spent',
                  NumberFormat.currency(
                    symbol: '\$', // Adjust currency symbol as needed
                    decimalDigits: 2,
                  ).format(customer.totalSpent),
                  Icons.attach_money_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (customer.firstPurchaseDate != null)
            _buildDetailRow(
              context,
              Icons.calendar_today_outlined,
              'First Purchase',
              dateFormat.format(customer.firstPurchaseDate!),
            ),
          if (customer.lastPurchaseDate != null)
            _buildDetailRow(
              context,
              Icons.event_repeat_outlined,
              'Last Purchase',
              dateFormat.format(customer.lastPurchaseDate!),
            ),
          const Divider(),
          _buildDetailRow(
            context,
            Icons.history_toggle_off_outlined,
            'Profile Created',
            dateTimeFormat.format(customer.createdAt),
          ),
          if (customer.updatedAt != null)
            _buildDetailRow(
              context,
              Icons.edit_calendar_outlined,
              'Last Updated',
              dateTimeFormat.format(customer.updatedAt!),
            ),
        ],
      ),
    );
  }
}

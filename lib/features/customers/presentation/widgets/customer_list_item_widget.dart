import 'package:flutter/material.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

class CustomerListItemWidget extends StatelessWidget {
  final CustomerEntity customer;
  final VoidCallback? onTap;

  const CustomerListItemWidget({super.key, required this.customer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        onTap: onTap,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primaryContainer,
          backgroundImage:
              customer.photoUrl != null && customer.photoUrl!.isNotEmpty
                  ? NetworkImage(customer.photoUrl!)
                  : null,
          child:
              (customer.photoUrl == null || customer.photoUrl!.isEmpty) &&
                      customer.name.isNotEmpty
                  ? Text(
                    customer.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                  : null,
        ),
        title: Text(
          customer.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2),
            if (customer.phoneNumber.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer.phoneNumber,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            if (customer.address.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      customer.address,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.outline),
      ),
    );
  }
}

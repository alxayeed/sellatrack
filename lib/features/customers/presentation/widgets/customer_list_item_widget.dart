import 'package:flutter/material.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

class CustomerListItemWidget extends StatelessWidget {
  final CustomerEntity customer;
  final VoidCallback? onTap;

  // final VoidCallback? onEdit; // Optional for later
  // final VoidCallback? onDelete; // Optional for later

  const CustomerListItemWidget({
    super.key,
    required this.customer,
    this.onTap,
    // this.onEdit,
    // this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          // backgroundImage: customer.photoUrl != null && customer.photoUrl!.isNotEmpty
          //     ? NetworkImage(customer.photoUrl!)
          //     : null, // Placeholder for NetworkImage once photoUrl is handled
          child:
              (customer.photoUrl == null || customer.photoUrl!.isEmpty)
                  ? Text(
                    customer.name.isNotEmpty
                        ? customer.name[0].toUpperCase()
                        : 'C',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                  : null, // If backgroundImage is used, child is not needed for text
        ),
        title: Text(
          customer.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (customer.phoneNumber.isNotEmpty)
              Text(
                customer.phoneNumber,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (customer.address.isNotEmpty)
              Text(
                customer.address, // Consider showing just city or a summary
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        // trailing: Row( // Optional: For Edit/Delete buttons directly on the item
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     if (onEdit != null) IconButton(icon: Icon(Icons.edit_outlined, color: theme.colorScheme.primary), onPressed: onEdit),
        //     if (onDelete != null) IconButton(icon: Icon(Icons.delete_outline, color: theme.colorScheme.error), onPressed: onDelete),
        //   ],
        // ),
      ),
    );
  }
}

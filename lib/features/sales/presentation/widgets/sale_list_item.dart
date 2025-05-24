import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/common.dart';
import '../../../../core/navigation/app_router.dart';
import '../../domain/entities/sale_entity.dart';

class SaleListItem extends StatelessWidget {
  final SaleEntity sale;

  final VoidCallback? onDelete;

  const SaleListItem({super.key, required this.sale, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoutePaths.saleDetailNamed, extra: sale);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sale.customerNameAtSale,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (onDelete != null)
                    CustomIconButtonWidget(
                      onPressed: onDelete,
                      iconData: Icons.delete_outline,
                      type: IconButtonType.subtle,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${sale.productDetails.productName} • ${sale.productDetails.quantity} ${sale.productDetails.unit}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sale.totalSaleAmount.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatDate(sale.date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

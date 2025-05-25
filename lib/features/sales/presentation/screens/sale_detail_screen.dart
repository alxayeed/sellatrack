import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/common/common.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';

import '../../../../core/navigation/app_router.dart';

class SaleDetailScreen extends StatelessWidget {
  final SaleEntity sale;

  const SaleDetailScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoCard(
              title: 'Customer',
              items: [
                _InfoItem(
                  icon: Icons.person_outline,
                  label: 'Name',
                  value: sale.customerNameAtSale,
                ),
                _InfoItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: sale.customerPhoneAtSale,
                ),
                _InfoItem(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: sale.customerAddressAtSale,
                ),
              ],
            ),
            const SizedBox(height: 4),
            _InfoCard(
              title: 'Product',
              items: [
                _InfoItem(
                  icon: Icons.shopping_bag,
                  label: 'Name',
                  value: sale.productDetails.productName,
                ),
                _InfoItem(
                  icon: Icons.scale,
                  label: 'Quantity',
                  value:
                      '${sale.productDetails.quantity} ${sale.productDetails.unit}',
                ),
                _InfoItem(
                  icon: Icons.attach_money,
                  label: 'Amount',
                  value: sale.productDetails.saleAmount.toStringAsFixed(2),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _InfoCard(
              title: 'Transaction',
              items: [
                _InfoItem(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: _formatDate(sale.date),
                ),
                _InfoItem(
                  icon: Icons.payment,
                  label: 'Payment Method',
                  value: sale.paymentMethod ?? 'Not specified',
                ),
                _InfoItem(
                  icon: Icons.note,
                  label: 'Notes',
                  value: sale.notes ?? 'No notes',
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              onPressed:
                  () => context.pushNamed(
                    AppRoutePaths.editSaleNamed,
                    extra: sale,
                  ),
              text: 'Edit',
              expand: true,
              isLoading: false,
              leadingIcon: Icon(Icons.edit, size: 18.sp),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoCard({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => item),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

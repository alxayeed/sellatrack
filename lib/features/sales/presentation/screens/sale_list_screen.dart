import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sellatrack/core/navigation/app_router.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';

import '../../../../core/common/common.dart';
import '../providers/sales_provider.dart';
import '../widgets/sale_list_item.dart';

class SalesListScreen extends ConsumerWidget {
  const SalesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesNotifierProvider);

    return Scaffold(
      body: salesState.when(
        loading: () => const CustomLoadingIndicatorWidget(),
        error:
            (error, _) => CustomErrorDisplayWidget(
              errorMessage: error.toString(),
              onRetry: () => ref.refresh(salesNotifierProvider),
            ),
        data:
            (sales) =>
                sales.isEmpty
                    ? CustomEmptyListWidget(
                      message: 'No sales records found',
                      icon: Icons.receipt_long,
                      retryButtonText: 'Refresh',
                      onRetry: () => ref.refresh(salesNotifierProvider),
                    )
                    : RefreshIndicator(
                      onRefresh:
                          () =>
                              ref
                                  .refresh(salesNotifierProvider.notifier)
                                  .loadSales(),
                      child: ListView.builder(
                        itemCount: sales.length,
                        itemBuilder:
                            (_, index) => SaleListItem(
                              sale: sales[index],
                              onDelete:
                                  () => _confirmDelete(
                                    context,
                                    ref,
                                    sales[index],
                                  ),
                            ),
                      ),
                    ),
      ),
      floatingActionButton: CustomElevatedButton(
        onPressed: () => context.pushNamed(AppRoutePaths.addSaleNamed),
        text: 'Add Sale',
        leadingIcon: const Icon(Icons.add),
        size: ButtonSize.large,
      ),
    );
  }

  void _showFilters(BuildContext context, WidgetRef ref) {
    // Implement filter dialog using your components
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, SaleEntity sale) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Delete sale record for ${sale.customerNameAtSale}?'),
            actions: [
              CustomTextButtonWidget(
                onPressed: () => Navigator.of(dialogContext).pop(),
                text: 'Cancel',
              ),
              CustomElevatedButton(
                onPressed: () {
                  ref
                      .read(salesNotifierProvider.notifier)
                      .softDeleteSale(sale.id, 'currentUserId');
                  Navigator.of(dialogContext).pop();
                  AppSnackBar.showSuccess(context, message: 'Sale deleted');
                },
                text: 'Delete',
                type: ButtonType.destructive,
              ),
            ],
          ),
    );
  }
}

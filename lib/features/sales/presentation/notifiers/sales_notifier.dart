import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';
import 'package:sellatrack/features/sales/domain/usecases/get_all_sales_usecase.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../domain/usecases/soft_delete_sale_usecase.dart';

class SalesNotifier extends StateNotifier<AsyncValue<List<SaleEntity>>> {
  final GetAllSalesUseCase _getAllSales;
  final SoftDeleteSaleUseCase _softDeleteSale;
  final Talker _talker;

  SalesNotifier(this._getAllSales, this._softDeleteSale, this._talker)
    : super(const AsyncValue.loading()) {
    loadSales();
  }

  Future<void> loadSales({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();
    final result = await _getAllSales.call(
      customerId: customerId,
      startDate: startDate,
      endDate: endDate,
    );

    state = result.fold((failure) {
      _talker.error('SalesNotifier.loadSales failed', failure);
      return AsyncValue.error(failure, StackTrace.current);
    }, (sales) => AsyncValue.data(sales));
  }

  Future<void> softDeleteSale(String saleId, String deletedByUid) async {
    try {
      // Perform backend deletion first
      await _softDeleteSale.call(saleId: saleId, deletedByUid: deletedByUid);
      _talker.info('Sale $saleId soft deleted');
      await loadSales();

      // Now update state only if backend confirms deletion
      // state = previousState.whenData(
      //   (sales) => sales.where((s) => s.id != saleId).toList(),
      // );
    } catch (e, st) {
      _talker.error('Failed to delete sale $saleId', e, st);
      // AppSnackBar.showError(globalNavigatorKey.currentContext!, message: 'Failed to delete sale');
    }
  }
}

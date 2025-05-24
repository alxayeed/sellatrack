import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../domain/entities/sale_entity.dart';
import '../../domain/params/sale_input_data.dart';
import '../../domain/usecases/add_sale_usecase.dart';
import '../../domain/usecases/update_sale_usecase.dart';
import '../providers/sales_provider.dart';

class AddEditSaleNotifier extends StateNotifier<AsyncValue<void>> {
  final AddSaleUseCase _addSale;
  final UpdateSaleUseCase _updateSale;
  final Ref _ref;
  final Talker _talker;

  AddEditSaleNotifier(this._addSale, this._updateSale, this._ref, this._talker)
    : super(const AsyncValue.data(null));

  /// Returns `true` if submit succeeded, `false` otherwise.
  Future<bool> submitSale({
    required bool isEditing,
    required SaleInputData input,
    SaleEntity? existingSale,
  }) async {
    state = const AsyncValue.loading();

    final result =
        isEditing
            ? await _updateSale.call(
              _mapInputToSaleEntity(input, existingSale!),
            )
            : await _addSale.call(input);

    return result.fold(
      (failure) {
        _talker.error('Submit sale failed', failure);
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (_) async {
        await _ref.read(salesNotifierProvider.notifier).loadSales();
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  SaleEntity _mapInputToSaleEntity(SaleInputData input, SaleEntity existing) {
    return existing.copyWith(
      date: input.saleDate,
      customerNameAtSale: input.customerNameForSale,
      customerPhoneAtSale: input.customerPhoneForSale,
      customerAddressAtSale: input.customerAddressForSale,
      productDetails: ProductSoldDetails(
        productName: input.productName,
        quantity: input.quantity,
        unit: input.unit,
        saleAmount: input.saleAmount,
      ),
      totalSaleAmount: input.saleAmount,
      paymentMethod: input.paymentMethod,
      notes: input.notes,
      updatedAt: DateTime.now(),
      lastUpdatedBy: input.recordedByAppUserId,
    );
  }
}

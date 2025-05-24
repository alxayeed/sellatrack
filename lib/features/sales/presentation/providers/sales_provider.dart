import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/core/logging/talker.dart';

import '../../domain/entities/sale_entity.dart';
import '../notifiers/add_edit_sale_notifier.dart';
import '../notifiers/sales_notifier.dart';

// Sales List Provider
final salesNotifierProvider = StateNotifierProvider.autoDispose<
  SalesNotifier,
  AsyncValue<List<SaleEntity>>
>((ref) {
  return SalesNotifier(
    ref.watch(getAllSalesUseCaseProvider),
    ref.watch(softDeleteSaleUseCaseProvider),
    ref.watch(talkerProvider),
  );
});

// Add/Edit Sale Provider
final addEditSaleNotifierProvider =
    StateNotifierProvider.autoDispose<AddEditSaleNotifier, AsyncValue<void>>((
      ref,
    ) {
      return AddEditSaleNotifier(
        ref.watch(addSaleUseCaseProvider),
        ref.watch(updateSaleUseCaseProvider),
        ref,
        ref.watch(talkerProvider),
      );
    });

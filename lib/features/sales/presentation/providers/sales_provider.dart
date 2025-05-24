import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/logging/talker.dart';

import '../../../../core/di/providers.dart';
import '../../domain/entities/sale_entity.dart';
import '../notifiers/sales_notifier.dart';

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

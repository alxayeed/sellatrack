import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_notifier.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';

final customerListNotifierProvider =
    StateNotifierProvider<CustomerListNotifier, CustomerListState>((ref) {
      final getAllCustomersUseCase = ref.watch(getAllCustomersUseCaseProvider);
      final deleteCustomerUseCase = ref.watch(deleteCustomerUseCaseProvider);
      final errorHandlerService = ref.watch(errorHandlerServiceProvider);

      return CustomerListNotifier(
        getAllCustomersUseCase: getAllCustomersUseCase,
        deleteCustomerUseCase: deleteCustomerUseCase,
        errorHandlerService: errorHandlerService,
      );
    });

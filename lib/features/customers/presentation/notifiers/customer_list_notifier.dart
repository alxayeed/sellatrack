import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/errors/error_handler_service.dart';
import 'package:sellatrack/features/customers/domain/usecases/delete_customer_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/get_all_customers_usecase.dart';

// Import other customer use cases as needed for this notifier

import 'customer_list_state.dart';

class CustomerListNotifier extends StateNotifier<CustomerListState> {
  final GetAllCustomersUseCase _getAllCustomersUseCase;
  final DeleteCustomerUseCase _deleteCustomerUseCase;

  // Add other use cases like AddCustomerUseCase, UpdateCustomerUseCase if this notifier handles those actions
  final ErrorHandlerService _errorHandlerService;

  CustomerListNotifier({
    required GetAllCustomersUseCase getAllCustomersUseCase,
    required DeleteCustomerUseCase deleteCustomerUseCase,
    required ErrorHandlerService errorHandlerService,
  }) : _getAllCustomersUseCase = getAllCustomersUseCase,
       _deleteCustomerUseCase = deleteCustomerUseCase,
       _errorHandlerService = errorHandlerService,
       super(const CustomerListState());

  Future<void> fetchCustomers({String? searchQuery}) async {
    state = state.copyWith(
      status: CustomerListStatus.loading,
      clearErrorMessage: true,
    );
    final result = await _getAllCustomersUseCase.call(searchQuery: searchQuery);

    result.fold(
      (failure) {
        final message = _errorHandlerService.processError(failure);
        state = state.copyWith(
          status: CustomerListStatus.error,
          errorMessage: message,
        );
      },
      (customers) {
        if (customers.isEmpty) {
          state = state.copyWith(
            status: CustomerListStatus.empty,
            customers: customers,
          );
        } else {
          state = state.copyWith(
            status: CustomerListStatus.success,
            customers: customers,
          );
        }
      },
    );
  }

  Future<void> deleteCustomer(String customerId) async {
    final result = await _deleteCustomerUseCase.call(customerId);

    result.fold(
      (failure) {
        final message = _errorHandlerService.processError(failure);
        state = state.copyWith(
          status: CustomerListStatus.error,
          errorMessage: message,
        );
      },
      (_) {
        fetchCustomers();
      },
    );
  }
}

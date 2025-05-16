import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/errors/error_handler_service.dart';
// To get current app user for recordedBy
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/usecases/add_customer_usecase.dart'; // Import AddCustomerUseCase
import 'package:sellatrack/features/customers/domain/usecases/delete_customer_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/get_all_customers_usecase.dart';

import 'customer_list_state.dart';

class CustomerListNotifier extends StateNotifier<CustomerListState> {
  final GetAllCustomersUseCase _getAllCustomersUseCase;
  final DeleteCustomerUseCase _deleteCustomerUseCase;
  final AddCustomerUseCase _addCustomerUseCase;
  final ErrorHandlerService _errorHandlerService;
  final String? _currentAppUserId;

  CustomerListNotifier({
    required GetAllCustomersUseCase getAllCustomersUseCase,
    required DeleteCustomerUseCase deleteCustomerUseCase,
    required AddCustomerUseCase addCustomerUseCase,
    required ErrorHandlerService errorHandlerService,
    required String? currentAppUserId,
  }) : _getAllCustomersUseCase = getAllCustomersUseCase,
       _deleteCustomerUseCase = deleteCustomerUseCase,
       _addCustomerUseCase = addCustomerUseCase,
       _errorHandlerService = errorHandlerService,
       _currentAppUserId = currentAppUserId,
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

  Future<bool> addCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    String? notes,
  }) async {
    if (_currentAppUserId == null) {
      state = state.copyWith(
        status: CustomerListStatus.error,
        errorMessage: "User not authenticated to add customer.",
      );
      return false;
    }
    final newCustomerData = CustomerEntity(
      id: '',
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      photoUrl: photoUrl,
      createdAt: DateTime.now(),
      recordedBy: _currentAppUserId,
      notes: notes,
      // Other fields like totalOrders, totalSpent default to 0
    );

    state = state.copyWith(
      status: CustomerListStatus.loading,
      clearErrorMessage: true,
    ); // Or a specific addLoading state
    final result = await _addCustomerUseCase.call(newCustomerData);

    bool success = false;
    result.fold(
      (failure) {
        final message = _errorHandlerService.processError(failure);
        state = state.copyWith(
          status: CustomerListStatus.error,
          errorMessage: message,
        );
        success = false;
      },
      (customerId) {
        state = state.copyWith(status: CustomerListStatus.success);
        fetchCustomers();
        success = true;
      },
    );
    return success;
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

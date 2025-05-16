import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_notifier.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';

final customerListNotifierProvider =
    StateNotifierProvider<CustomerListNotifier, CustomerListState>((ref) {
      final getAllCustomersUseCase = ref.watch(getAllCustomersUseCaseProvider);
      final deleteCustomerUseCase = ref.watch(deleteCustomerUseCaseProvider);
      final addCustomerUseCase = ref.watch(
        addCustomerUseCaseProvider,
      ); // Get AddCustomerUseCase
      final errorHandlerService = ref.watch(errorHandlerServiceProvider);

      // Get current authenticated app user's ID for 'recordedBy'
      final currentAuthUserAsync = ref.watch(authStateChangesProvider);
      final String? currentAppUserId = currentAuthUserAsync.valueOrNull?.uid;

      return CustomerListNotifier(
        getAllCustomersUseCase: getAllCustomersUseCase,
        deleteCustomerUseCase: deleteCustomerUseCase,
        addCustomerUseCase: addCustomerUseCase,
        // Inject it
        errorHandlerService: errorHandlerService,
        currentAppUserId: currentAppUserId,
      );
    });

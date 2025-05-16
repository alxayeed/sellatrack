import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/core/di/providers.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart'; // For AuthUserEntity type
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_notifier.dart';
import 'package:sellatrack/features/customers/presentation/notifiers/customer_list_state.dart';

final customerListNotifierProvider =
    StateNotifierProvider<CustomerListNotifier, CustomerListState>((ref) {
      final getAllCustomersUseCase = ref.watch(getAllCustomersUseCaseProvider);
      final deleteCustomerUseCase = ref.watch(deleteCustomerUseCaseProvider);
      final addCustomerUseCase = ref.watch(addCustomerUseCaseProvider);
      final updateCustomerUseCase = ref.watch(
        updateCustomerUseCaseProvider,
      ); // Added
      final errorHandlerService = ref.watch(errorHandlerServiceProvider);

      final AsyncValue<AuthUserEntity?> currentAuthUserAsync = ref.watch(
        authStateChangesProvider,
      );
      final String? currentAppUserId = currentAuthUserAsync.valueOrNull?.uid;

      return CustomerListNotifier(
        getAllCustomersUseCase: getAllCustomersUseCase,
        deleteCustomerUseCase: deleteCustomerUseCase,
        addCustomerUseCase: addCustomerUseCase,
        updateCustomerUseCase: updateCustomerUseCase,
        // Added
        errorHandlerService: errorHandlerService,
        currentAppUserId: currentAppUserId,
      );
    });

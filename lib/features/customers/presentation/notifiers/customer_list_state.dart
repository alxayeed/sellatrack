import 'package:equatable/equatable.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

enum CustomerListStatus {
  initial,
  loading,
  success,
  error,
  empty, // Optional: for when the list is successfully fetched but empty
}

class CustomerListState extends Equatable {
  final CustomerListStatus status;
  final List<CustomerEntity> customers;
  final String? errorMessage;

  // Optional: Add fields for pagination if needed later
  // final bool hasReachedMax;
  // final int currentPage;

  const CustomerListState({
    this.status = CustomerListStatus.initial,
    this.customers = const [],
    this.errorMessage,
    // this.hasReachedMax = false,
    // this.currentPage = 0,
  });

  CustomerListState copyWith({
    CustomerListStatus? status,
    List<CustomerEntity>? customers,
    String? errorMessage,
    bool clearErrorMessage = false,
    // bool? hasReachedMax,
    // int? currentPage,
  }) {
    return CustomerListState(
      status: status ?? this.status,
      customers: customers ?? this.customers,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      // hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      // currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    customers,
    errorMessage,
    // hasReachedMax,
    // currentPage,
  ];
}

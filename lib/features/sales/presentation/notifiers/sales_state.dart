import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/sale_entity.dart';

enum SalesStatus { initial, loading, success, error, empty, adding, deleting }

class SalesState extends Equatable {
  final SalesStatus status;
  final List<SaleEntity> sales;
  final String? errorMessage;
  final String? filterCustomerId;
  final DateTimeRange? filterDateRange;

  const SalesState({
    this.status = SalesStatus.initial,
    this.sales = const [],
    this.errorMessage,
    this.filterCustomerId,
    this.filterDateRange,
  });

  SalesState copyWith({
    SalesStatus? status,
    List<SaleEntity>? sales,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? filterCustomerId,
    DateTimeRange? filterDateRange,
  }) {
    return SalesState(
      status: status ?? this.status,
      sales: sales ?? this.sales,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      filterCustomerId: filterCustomerId ?? this.filterCustomerId,
      filterDateRange: filterDateRange ?? this.filterDateRange,
    );
  }

  @override
  List<Object?> get props => [
    status,
    sales,
    errorMessage,
    filterCustomerId,
    filterDateRange,
  ];
}

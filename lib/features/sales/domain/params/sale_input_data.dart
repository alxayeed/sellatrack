import 'package:equatable/equatable.dart';

class SaleInputData extends Equatable {
  final DateTime saleDate;

  // Customer details from the sale form
  final String customerNameForSale;
  final String customerPhoneForSale;
  final String customerAddressForSale;
  final String? customerEmailForSale;
  final String? customerPhotoUrlForSale;

  // Product details from the sale form
  final String productName;
  final num quantity;
  final String unit;
  final double saleAmount;

  // Other sale details
  final String? paymentMethod;
  final String? notes;
  final String recordedByAppUserId;

  const SaleInputData({
    required this.saleDate,
    required this.customerNameForSale,
    required this.customerPhoneForSale,
    required this.customerAddressForSale,
    this.customerEmailForSale,
    this.customerPhotoUrlForSale,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.saleAmount,
    this.paymentMethod,
    this.notes,
    required this.recordedByAppUserId,
  });

  @override
  List<Object?> get props => [
    saleDate,
    customerNameForSale,
    customerPhoneForSale,
    customerAddressForSale,
    customerEmailForSale,
    customerPhotoUrlForSale,
    productName,
    quantity,
    unit,
    saleAmount,
    paymentMethod,
    notes,
    recordedByAppUserId,
  ];
}

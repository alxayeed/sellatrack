import 'package:equatable/equatable.dart';

class ProductSoldDetails extends Equatable {
  final String productName;
  final num quantity;
  final String unit;
  final double saleAmount;

  const ProductSoldDetails({
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.saleAmount,
  });

  ProductSoldDetails copyWith({
    String? productName,
    num? quantity,
    String? unit,
    double? saleAmount,
  }) {
    return ProductSoldDetails(
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      saleAmount: saleAmount ?? this.saleAmount,
    );
  }

  @override
  List<Object?> get props => [productName, quantity, unit, saleAmount];
}

class SaleEntity extends Equatable {
  final String id;
  final DateTime date;
  final String customerId;
  final String customerNameAtSale;
  final String customerPhoneAtSale;
  final String customerAddressAtSale;
  final ProductSoldDetails productDetails;

  // final List<SaleItemEntity> items; // For multiple items per sale - future
  final double totalSaleAmount;
  final String? paymentMethod;
  final String? notes;
  final String recordedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? lastUpdatedBy;
  final bool isDeleted;
  final DateTime? deletedAt;

  const SaleEntity({
    required this.id,
    required this.date,
    required this.customerId,
    required this.customerNameAtSale,
    required this.customerPhoneAtSale,
    required this.customerAddressAtSale,
    required this.productDetails,
    // required this.items, // For multiple items
    required this.totalSaleAmount,
    this.paymentMethod,
    this.notes,
    required this.recordedBy,
    required this.createdAt,
    this.updatedAt,
    this.lastUpdatedBy,
    this.isDeleted = false,
    this.deletedAt,
  });

  SaleEntity copyWith({
    String? id,
    DateTime? date,
    String? customerId,
    String? customerNameAtSale,
    String? customerPhoneAtSale,
    String? customerAddressAtSale,
    ProductSoldDetails? productDetails,
    // List<SaleItemEntity>? items,
    double? totalSaleAmount,
    String? paymentMethod,
    bool clearPaymentMethod = false,
    String? notes,
    bool clearNotes = false,
    String? recordedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearUpdatedAt = false,
    String? lastUpdatedBy,
    bool clearLastUpdatedBy = false,
    bool? isDeleted,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return SaleEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      customerId: customerId ?? this.customerId,
      customerNameAtSale: customerNameAtSale ?? this.customerNameAtSale,
      customerPhoneAtSale: customerPhoneAtSale ?? this.customerPhoneAtSale,
      customerAddressAtSale:
          customerAddressAtSale ?? this.customerAddressAtSale,
      productDetails: productDetails ?? this.productDetails,
      // items: items ?? this.items,
      totalSaleAmount: totalSaleAmount ?? this.totalSaleAmount,
      paymentMethod:
          clearPaymentMethod ? null : paymentMethod ?? this.paymentMethod,
      notes: clearNotes ? null : notes ?? this.notes,
      recordedBy: recordedBy ?? this.recordedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt ? null : updatedAt ?? this.updatedAt,
      lastUpdatedBy:
          clearLastUpdatedBy ? null : lastUpdatedBy ?? this.lastUpdatedBy,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: clearDeletedAt ? null : deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    date,
    customerId,
    customerNameAtSale,
    customerPhoneAtSale,
    customerAddressAtSale,
    productDetails,
    // items,
    totalSaleAmount,
    paymentMethod,
    notes,
    recordedBy,
    createdAt,
    updatedAt,
    lastUpdatedBy,
    isDeleted,
    deletedAt,
  ];

  @override
  bool get stringify => true;
}

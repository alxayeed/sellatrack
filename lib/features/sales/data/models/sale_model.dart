import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellatrack/features/sales/data/models/product_sold_details_model.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';

class SaleModel extends SaleEntity {
  const SaleModel({
    required super.id,
    required super.date,
    required super.customerId,
    required super.customerNameAtSale,
    required super.customerPhoneAtSale,
    required super.customerAddressAtSale,
    required super.productDetails,
    required super.totalSaleAmount,
    super.paymentMethod,
    super.notes,
    required super.recordedBy,
    required super.createdAt,
    super.updatedAt,
    super.lastUpdatedBy,
    super.isDeleted = false,
    super.deletedAt,
  });

  factory SaleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Sale document data is null!");
    }

    // Deserialize productDetails from its map representation
    final productDetailsMap = data['productDetails'] as Map<String, dynamic>?;
    if (productDetailsMap == null) {
      throw Exception("Product details are missing in sale document!");
    }
    final productDetails = ProductSoldDetailsModel.fromMap(productDetailsMap);

    return SaleModel(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      customerId: data['customerId'] as String,
      customerNameAtSale: data['customerNameAtSale'] as String,
      customerPhoneAtSale: data['customerPhoneAtSale'] as String,
      customerAddressAtSale: data['customerAddressAtSale'] as String,
      productDetails: productDetails,
      totalSaleAmount: (data['totalSaleAmount'] as num).toDouble(),
      paymentMethod: data['paymentMethod'] as String?,
      notes: data['notes'] as String?,
      recordedBy: data['recordedBy'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      lastUpdatedBy: data['lastUpdatedBy'] as String?,
      isDeleted: data['isDeleted'] as bool? ?? false,
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'date': Timestamp.fromDate(date),
      'customerId': customerId,
      'customerNameAtSale': customerNameAtSale,
      'customerPhoneAtSale': customerPhoneAtSale,
      'customerAddressAtSale': customerAddressAtSale,
      'productDetails':
          productDetails is ProductSoldDetailsModel
              ? (productDetails as ProductSoldDetailsModel).toMap()
              : ProductSoldDetailsModel.fromEntity(productDetails).toMap(),
      'totalSaleAmount': totalSaleAmount,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'recordedBy': recordedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'lastUpdatedBy': lastUpdatedBy,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt == null ? null : Timestamp.fromDate(deletedAt!),
    };
  }

  factory SaleModel.fromEntity(SaleEntity entity) {
    return SaleModel(
      id: entity.id,
      date: entity.date,
      customerId: entity.customerId,
      customerNameAtSale: entity.customerNameAtSale,
      customerPhoneAtSale: entity.customerPhoneAtSale,
      customerAddressAtSale: entity.customerAddressAtSale,
      productDetails: ProductSoldDetailsModel.fromEntity(entity.productDetails),
      // Ensure proper conversion
      totalSaleAmount: entity.totalSaleAmount,
      paymentMethod: entity.paymentMethod,
      notes: entity.notes,
      recordedBy: entity.recordedBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastUpdatedBy: entity.lastUpdatedBy,
      isDeleted: entity.isDeleted,
      deletedAt: entity.deletedAt,
    );
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      date: date,
      customerId: customerId,
      customerNameAtSale: customerNameAtSale,
      customerPhoneAtSale: customerPhoneAtSale,
      customerAddressAtSale: customerAddressAtSale,
      productDetails: productDetails,
      // Direct pass-through as it's already the correct type
      totalSaleAmount: totalSaleAmount,
      paymentMethod: paymentMethod,
      notes: notes,
      recordedBy: recordedBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastUpdatedBy: lastUpdatedBy,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
    );
  }
}

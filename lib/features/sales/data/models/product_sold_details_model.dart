import '../../domain/entities/sale_entity.dart';

class ProductSoldDetailsModel extends ProductSoldDetails {
  const ProductSoldDetailsModel({
    required super.productName,
    required super.quantity,
    required super.unit,
    required super.saleAmount,
  });

  factory ProductSoldDetailsModel.fromMap(Map<String, dynamic> map) {
    return ProductSoldDetailsModel(
      productName: map['productName'] as String,
      quantity: map['quantity'] as num,
      unit: map['unit'] as String,
      saleAmount: (map['saleAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'unit': unit,
      'saleAmount': saleAmount,
    };
  }

  factory ProductSoldDetailsModel.fromEntity(ProductSoldDetails entity) {
    return ProductSoldDetailsModel(
      productName: entity.productName,
      quantity: entity.quantity,
      unit: entity.unit,
      saleAmount: entity.saleAmount,
    );
  }

  // toEntity() is inherited from ProductSoldDetails via SaleModel extending SaleEntity,
  // but since ProductSoldDetails itself is an entity, we can make it explicit
  // or rely on the fact that this IS-A ProductSoldDetails.
  // For consistency, let's add it, though it might seem redundant if no extra fields are in the model.
  ProductSoldDetails toEntity() {
    return ProductSoldDetails(
      productName: productName,
      quantity: quantity,
      unit: unit,
      saleAmount: saleAmount,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class UpdateSaleUseCase {
  final SaleRepository repository;

  UpdateSaleUseCase(this.repository);

  Future<Either<Failure, void>> call(SaleEntity saleData) async {
    if (saleData.id.isEmpty) {
      return Left(
        InvalidInputFailure(message: 'Sale ID is required for update.'),
      );
    }
    if (saleData.productDetails.productName.isEmpty ||
        saleData.productDetails.quantity <= 0 ||
        saleData.productDetails.unit.isEmpty ||
        saleData.productDetails.saleAmount < 0) {
      return Left(
        InvalidInputFailure(
          message: 'Product details for sale update are invalid.',
        ),
      );
    }
    // Consider if customer details on the sale record itself can be updated,
    // or if that requires changing the linked customer.
    // For now, assumes saleData contains all fields to be updated.
    return repository.updateSale(saleData);
  }
}

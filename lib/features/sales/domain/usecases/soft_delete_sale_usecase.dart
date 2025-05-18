import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../repositories/sale_repository.dart';

class SoftDeleteSaleUseCase {
  final SaleRepository repository;

  SoftDeleteSaleUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String saleId,
    required String deletedByUid,
  }) async {
    if (saleId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Sale ID cannot be empty.'));
    }
    if (deletedByUid.isEmpty) {
      return Left(
        InvalidInputFailure(message: 'User ID for deletion cannot be empty.'),
      );
    }
    return repository.softDeleteSale(
      saleId: saleId,
      deletedByUid: deletedByUid,
    );
  }
}

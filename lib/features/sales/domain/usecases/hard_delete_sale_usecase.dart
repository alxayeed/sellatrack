import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../repositories/sale_repository.dart';

class HardDeleteSaleUseCase {
  final SaleRepository repository;

  HardDeleteSaleUseCase(this.repository);

  Future<Either<Failure, void>> call(String saleId) async {
    if (saleId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Sale ID cannot be empty.'));
    }
    return repository.hardDeleteSale(saleId);
  }
}

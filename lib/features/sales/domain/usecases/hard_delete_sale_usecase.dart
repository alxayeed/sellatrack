import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../../../../core/logging/talker.dart';
import '../repositories/sale_repository.dart';

class HardDeleteSaleUseCase {
  final SaleRepository repository;

  HardDeleteSaleUseCase(this.repository);

  Future<Either<Failure, void>> call(String saleId) async {
    talker.debug('Attempted hard delete on sale $saleId (blocked)');
    return Left(
      UnsupportedFailure(message: 'Hard deletes are disabled. Use softDelete.'),
    );
    if (saleId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Sale ID cannot be empty.'));
    }
    return repository.hardDeleteSale(saleId);
  }
}

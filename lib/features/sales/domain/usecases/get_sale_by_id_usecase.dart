import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GetSaleByIdUseCase {
  final SaleRepository repository;

  GetSaleByIdUseCase(this.repository);

  Future<Either<Failure, SaleEntity?>> call(String id) async {
    if (id.isEmpty) {
      return Left(InvalidInputFailure(message: 'Sale ID cannot be empty.'));
    }
    return repository.getSaleById(id);
  }
}

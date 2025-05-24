import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GetSalesByCustomerUseCase {
  final SaleRepository repository;

  GetSalesByCustomerUseCase(this.repository);

  Future<Either<Failure, List<SaleEntity>>> call(String customerId) async {
    if (customerId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    return repository.getAllSales(customerId: customerId);
  }
}

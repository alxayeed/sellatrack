import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GetAllSalesUseCase {
  final SaleRepository repository;

  GetAllSalesUseCase(this.repository);

  Future<Either<Failure, List<SaleEntity>>> call({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return repository.getAllSales(
      customerId: customerId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

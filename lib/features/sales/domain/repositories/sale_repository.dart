import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';

import '../entities/sale_entity.dart';

abstract class SaleRepository {
  Future<Either<Failure, SaleEntity?>> getSaleById(String id);

  Future<Either<Failure, List<SaleEntity>>> getAllSales({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
    // Add sorting options later if needed
  });

  Future<Either<Failure, String>> addSale(SaleEntity saleData);

  Future<Either<Failure, void>> updateSale(SaleEntity saleData);

  Future<Either<Failure, void>> softDeleteSale({
    required String saleId,
    required String deletedByUid,
  });

  Future<Either<Failure, void>> restoreSale(String saleId);

  Future<Either<Failure, void>> hardDeleteSale(String saleId);
}

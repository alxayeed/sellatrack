import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerPurchaseStatsUseCase {
  final CustomerRepository repository;

  UpdateCustomerPurchaseStatsUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  }) async {
    if (customerId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    if (saleAmount < 0) {
      return Left(
        InvalidInputFailure(message: 'Sale amount cannot be negative.'),
      );
    }
    return repository.updateCustomerPurchaseStats(
      customerId: customerId,
      saleAmount: saleAmount,
      purchaseDate: purchaseDate,
    );
  }
}

import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class DeleteCustomerPhotoUseCase {
  final CustomerRepository repository;

  DeleteCustomerPhotoUseCase(this.repository);

  Future<Either<Failure, void>> call(String customerId) async {
    if (customerId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    return repository.deleteCustomerPhoto(customerId: customerId);
  }
}

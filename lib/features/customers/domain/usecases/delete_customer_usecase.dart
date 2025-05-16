import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class DeleteCustomerUseCase {
  final CustomerRepository repository;

  DeleteCustomerUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    if (id.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    return repository.deleteCustomer(id);
  }
}

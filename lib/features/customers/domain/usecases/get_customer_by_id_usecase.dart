import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class GetCustomerByIdUseCase {
  final CustomerRepository repository;

  GetCustomerByIdUseCase(this.repository);

  Future<Either<Failure, CustomerEntity?>> call(String id) async {
    if (id.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    return repository.getCustomerById(id);
  }
}

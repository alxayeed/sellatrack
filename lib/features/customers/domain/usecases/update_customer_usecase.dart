import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerUseCase {
  final CustomerRepository repository;

  UpdateCustomerUseCase(this.repository);

  Future<Either<Failure, void>> call(CustomerEntity customerData) async {
    if (customerData.id.isEmpty) {
      return Left(
        InvalidInputFailure(message: 'Customer ID is required for an update.'),
      );
    }
    if (customerData.name.isEmpty ||
        customerData.phoneNumber.isEmpty ||
        customerData.address.isEmpty) {
      return Left(
        InvalidInputFailure(
          message: 'Name, phone number, and address cannot be empty.',
        ),
      );
    }
    return repository.updateCustomer(customerData);
  }
}

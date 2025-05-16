import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class AddCustomerUseCase {
  final CustomerRepository repository;

  AddCustomerUseCase(this.repository);

  Future<Either<Failure, String>> call(CustomerEntity customerData) async {
    if (customerData.name.isEmpty ||
        customerData.phoneNumber.isEmpty ||
        customerData.address.isEmpty) {
      return Left(
        InvalidInputFailure(
          message: 'Name, phone number, and address are required.',
        ),
      );
    }
    return repository.addCustomer(customerData);
  }
}

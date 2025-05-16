import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class FindCustomerByPhoneNumberUseCase {
  final CustomerRepository repository;

  FindCustomerByPhoneNumberUseCase(this.repository);

  Future<Either<Failure, CustomerEntity?>> call(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      return Left(
        InvalidInputFailure(message: 'Phone number cannot be empty.'),
      );
    }
    return repository.findCustomerByPhoneNumber(phoneNumber);
  }
}

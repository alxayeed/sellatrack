import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class FindCustomerByPhoneNumberUseCase {
  final CustomerRepository repository;

  FindCustomerByPhoneNumberUseCase(this.repository);

  Future<CustomerEntity?> call(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      throw ArgumentError('Phone number cannot be empty.');
    }
    return repository.findCustomerByPhoneNumber(phoneNumber);
  }
}

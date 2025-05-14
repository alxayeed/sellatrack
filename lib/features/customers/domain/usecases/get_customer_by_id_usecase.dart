import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class GetCustomerByIdUseCase {
  final CustomerRepository repository;

  GetCustomerByIdUseCase(this.repository);

  Future<CustomerEntity?> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty.');
    }
    return repository.getCustomerById(id);
  }
}

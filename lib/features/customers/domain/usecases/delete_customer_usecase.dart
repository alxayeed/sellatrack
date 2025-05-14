import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class DeleteCustomerUseCase {
  final CustomerRepository repository;

  DeleteCustomerUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty.');
    }
    return repository.deleteCustomer(id);
  }
}

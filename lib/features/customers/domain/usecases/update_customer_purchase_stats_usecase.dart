import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerUseCase {
  final CustomerRepository repository;

  UpdateCustomerUseCase(this.repository);

  Future<void> call(CustomerEntity customerData) async {
    if (customerData.id.isEmpty) {
      throw ArgumentError('Customer ID is required for an update.');
    }
    if (customerData.name.isEmpty ||
        customerData.phoneNumber.isEmpty ||
        customerData.address.isEmpty) {
      throw ArgumentError('Name, phone number, and address cannot be empty.');
    }
    return repository.updateCustomer(customerData);
  }
}

import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class DeleteCustomerPhotoUseCase {
  final CustomerRepository repository;

  DeleteCustomerPhotoUseCase(this.repository);

  Future<void> call(String customerId) async {
    if (customerId.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty.');
    }
    return repository.deleteCustomerPhoto(customerId: customerId);
  }
}

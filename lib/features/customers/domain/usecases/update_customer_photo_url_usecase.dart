import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerPhotoUrlUseCase {
  final CustomerRepository repository;

  UpdateCustomerPhotoUrlUseCase(this.repository);

  Future<void> call({
    required String customerId,
    required String? photoUrl,
  }) async {
    if (customerId.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty.');
    }
    // Basic URL validation could be added here if photoUrl is not null
    return repository.updateCustomerPhotoUrl(
      customerId: customerId,
      photoUrl: photoUrl,
    );
  }
}

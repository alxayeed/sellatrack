import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerPhotoUrlUseCase {
  final CustomerRepository repository;

  UpdateCustomerPhotoUrlUseCase(this.repository);

  Future<void> call({
    required String customerId,
    required String photoUrl, // Now non-nullable
  }) async {
    if (customerId.isEmpty) {
      throw ArgumentError('Customer ID cannot be empty.');
    }
    if (photoUrl.isEmpty) {
      throw ArgumentError('Photo URL cannot be empty when updating.');
    }
    // Basic URL validation could be added here
    return repository.updateCustomerPhotoUrl(
      customerId: customerId,
      photoUrl: photoUrl,
    );
  }
}

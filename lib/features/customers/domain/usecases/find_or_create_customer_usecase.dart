import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class FindOrCreateCustomerUseCase {
  final CustomerRepository repository;

  FindOrCreateCustomerUseCase(this.repository);

  Future<CustomerEntity> call({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
  }) async {
    if (name.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty ||
        recordedByUid.isEmpty) {
      throw ArgumentError(
        'Name, phone number, address, and recordedBy UID are required.',
      );
    }
    return repository.findOrCreateCustomer(
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      photoUrl: photoUrl,
      recordedByUid: recordedByUid,
    );
  }
}

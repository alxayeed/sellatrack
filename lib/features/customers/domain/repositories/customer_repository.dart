import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<CustomerEntity?> getCustomerById(String id);

  Future<List<CustomerEntity>> getAllCustomers({String? searchQuery});

  Future<CustomerEntity?> findCustomerByPhoneNumber(String phoneNumber);

  Future<String> addCustomer(CustomerEntity customerData);

  Future<CustomerEntity> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
  });

  Future<void> updateCustomer(CustomerEntity customerData);

  Future<void> updateCustomerPhotoUrl({
    required String customerId,
    required String? photoUrl,
  });

  Future<void> deleteCustomer(String id);

  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  });

  Future<void> deleteCustomerPhoto({required String customerId});
}

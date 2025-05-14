import 'package:sellatrack/features/customers/data/models/customer_model.dart';

abstract class CustomerRemoteDatasource {
  Future<CustomerModel?> getCustomerById(String id);

  Future<List<CustomerModel>> getAllCustomers({String? searchQuery});

  Future<CustomerModel?> findCustomerByPhoneNumber(String phoneNumber);

  Future<String> addCustomer(CustomerModel customerModel);

  Future<CustomerModel> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
    required DateTime createdAt,
  });

  Future<void> updateCustomer(CustomerModel customerModel);

  Future<void> updateCustomerPhotoUrl({
    required String customerId,
    required String? photoUrl,
  });

  Future<void> deleteCustomerPhoto({required String customerId});

  Future<void> deleteCustomer(String id);

  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  });
}

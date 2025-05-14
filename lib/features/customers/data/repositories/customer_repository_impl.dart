import 'package:sellatrack/features/customers/data/datasources/customer_remote_datasource.dart';
import 'package:sellatrack/features/customers/data/models/customer_model.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDatasource remoteDatasource;

  // final CustomerLocalDatasource localDatasource; // For later, if adding local cache/DB

  CustomerRepositoryImpl({
    required this.remoteDatasource,
    // required this.localDatasource, // For later
  });

  @override
  Future<String> addCustomer(CustomerEntity customerData) async {
    try {
      // The domain passes a CustomerEntity. We need to convert it to CustomerModel
      // before sending to the datasource, which expects CustomerModel for addCustomer.
      // However, our CustomerModel.fromEntity also needs an ID, but addCustomer
      // in the datasource generates the ID.
      // Let's assume addCustomer in datasource takes a model without ID,
      // or we create a model here and the datasource populates ID.
      // For now, let's create a CustomerModel. The ID field will be ignored by
      // the datasource's addCustomer if it generates its own ID.
      // Alternatively, the datasource addCustomer could take simpler parameters.

      // Let's refine this. The CustomerEntity passed for adding typically won't have an ID.
      // The model created for the datasource also might not have an ID initially.
      // The datasource's addCustomer method should take a CustomerModel
      // that might have a temporary or empty ID, and it's responsible for persistence.
      // The `customerData` here will not have an ID yet.
      // The CustomerModel constructor requires an ID.
      // This implies addCustomer in the repository should perhaps take individual fields
      // or the entity should allow creation without an ID for this specific purpose.

      // Let's assume CustomerModel can be created for the map without an ID,
      // or the addCustomer in datasource handles this.
      // For this implementation, we'll convert to a model, and the datasource's
      // addCustomer should handle the ID generation from the data it receives.
      // The `id` in `customerData` for `addCustomer` is problematic if it's pre-filled.
      // Let's assume `customerData` for `addCustomer` is built without an ID.
      // We'll make a temporary CustomerModel.
      // This highlights a slight mismatch if CustomerEntity requires an ID always.

      // Simplification: The addCustomer in datasource takes CustomerModel.
      // The CustomerModel passed to it here will have a dummy ID which the
      // datasource's addCustomer will ignore as it creates a new document.
      final customerModel = CustomerModel.fromEntity(customerData);
      return await remoteDatasource.addCustomer(customerModel);
    } catch (e) {
      throw Exception('Failed to add customer: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      return await remoteDatasource.deleteCustomer(id);
    } catch (e) {
      throw Exception('Failed to delete customer: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCustomerPhoto({required String customerId}) async {
    try {
      // Before deleting photo reference, get current photoUrl to delete from Storage
      final customerModel = await remoteDatasource.getCustomerById(customerId);
      final existingPhotoUrl = customerModel?.photoUrl;

      await remoteDatasource.deleteCustomerPhoto(customerId: customerId);

      if (existingPhotoUrl != null && existingPhotoUrl.isNotEmpty) {
        // TODO: Implement actual deletion from Firebase Storage here
        // This would involve calling a FirebaseStorageService.deleteFile(existingPhotoUrl)
        // For now, we are just removing the reference from Firestore.
        print('TODO: Delete file from storage: $existingPhotoUrl');
      }
    } catch (e) {
      throw Exception('Failed to delete customer photo: ${e.toString()}');
    }
  }

  @override
  Future<CustomerEntity> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
  }) async {
    try {
      // Datasource handles creation time
      final customerModel = await remoteDatasource.findOrCreateCustomer(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        photoUrl: photoUrl,
        recordedByUid: recordedByUid,
        createdAt: DateTime.now(), // Repository sets the creation time
      );
      return customerModel.toEntity();
    } catch (e) {
      throw Exception('Failed to find or create customer: ${e.toString()}');
    }
  }

  @override
  Future<CustomerEntity?> findCustomerByPhoneNumber(String phoneNumber) async {
    try {
      final customerModel = await remoteDatasource.findCustomerByPhoneNumber(
        phoneNumber,
      );
      return customerModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to find customer by phone: ${e.toString()}');
    }
  }

  @override
  Future<List<CustomerEntity>> getAllCustomers({String? searchQuery}) async {
    try {
      final customerModels = await remoteDatasource.getAllCustomers(
        searchQuery: searchQuery,
      );
      return customerModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all customers: ${e.toString()}');
    }
  }

  @override
  Future<CustomerEntity?> getCustomerById(String id) async {
    try {
      final customerModel = await remoteDatasource.getCustomerById(id);
      return customerModel?.toEntity();
    } catch (e) {
      throw Exception('Failed to get customer by ID: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCustomer(CustomerEntity customerData) async {
    try {
      final now = DateTime.now();
      // Assuming current app user's UID is accessible, e.g., via an AuthRepository or passed down.
      // String currentAppUserUid = _authRepository.getCurrentUser()?.uid ?? 'unknown_updater';

      final customerModel = CustomerModel.fromEntity(
        customerData.copyWith(
          updatedAt: now,
          // lastUpdatedBy: currentAppUserUid, // Set this if available
        ),
      );
      return await remoteDatasource.updateCustomer(customerModel);
    } catch (e) {
      throw Exception('Failed to update customer: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCustomerPhotoUrl({
    required String customerId,
    required String? photoUrl,
  }) async {
    try {
      // If removing a photo (photoUrl is null), first get existing URL to delete from Storage.
      String? oldPhotoUrl;
      if (photoUrl == null) {
        final existingCustomerModel = await remoteDatasource.getCustomerById(
          customerId,
        );
        oldPhotoUrl = existingCustomerModel?.photoUrl;
      }

      await remoteDatasource.updateCustomerPhotoUrl(
        customerId: customerId,
        photoUrl: photoUrl,
      );

      if (oldPhotoUrl != null && oldPhotoUrl.isNotEmpty && photoUrl == null) {
        // This means the photo was removed. Delete from storage.
        // TODO: Implement actual deletion from Firebase Storage here
        print('TODO: Delete file from storage: $oldPhotoUrl');
      }
      // If photoUrl is being set to a new URL, the old file might become orphaned
      // if not explicitly deleted. Managing storage file lifecycle is important.
      // The UI/Service that uploaded the *new* photo might be responsible for deleting the old one
      // if it knows the old URL. Or, this repository method could handle it.
    } catch (e) {
      throw Exception('Failed to update customer photo URL: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  }) async {
    try {
      // Here, we also need to ensure lastUpdatedBy is set.
      // This could be passed down or fetched.
      // String currentAppUserUid = ...;
      // The datasource method itself might handle setting updatedAt internally if using FieldValue.serverTimestamp().
      return await remoteDatasource.updateCustomerPurchaseStats(
        customerId: customerId,
        saleAmount: saleAmount,
        purchaseDate: purchaseDate,
        // lastUpdatedBy: currentAppUserUid, // Pass if datasource method accepts it
      );
    } catch (e) {
      throw Exception(
        'Failed to update customer purchase stats: ${e.toString()}',
      );
    }
  }
}

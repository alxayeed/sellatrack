import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<Either<Failure, CustomerEntity?>> getCustomerById(String id);

  Future<Either<Failure, List<CustomerEntity>>> getAllCustomers({
    String? searchQuery,
  });

  Future<Either<Failure, CustomerEntity?>> findCustomerByPhoneNumber(
    String phoneNumber,
  );

  Future<Either<Failure, String>> addCustomer(CustomerEntity customerData);

  Future<Either<Failure, CustomerEntity>> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
    // Note: createdAt is usually set by the repository impl or datasource
  });

  Future<Either<Failure, void>> updateCustomer(CustomerEntity customerData);

  Future<Either<Failure, void>> updateCustomerPhotoUrl({
    required String customerId,
    required String photoUrl,
  });

  Future<Either<Failure, void>> deleteCustomerPhoto({
    required String customerId,
  });

  Future<Either<Failure, void>> deleteCustomer(String id);

  Future<Either<Failure, void>> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  });
}

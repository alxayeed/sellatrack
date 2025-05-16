import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/core/logging/talker.dart';
import 'package:sellatrack/features/customers/data/datasources/customer_remote_datasource.dart';
import 'package:sellatrack/features/customers/data/models/customer_model.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDatasource remoteDatasource;

  CustomerRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, String>> addCustomer(
    CustomerEntity customerData,
  ) async {
    try {
      final customerModel = CustomerModel.fromEntity(customerData);
      final customerId = await remoteDatasource.addCustomer(customerModel);
      return Right(customerId);
    } on FirebaseException catch (e, s) {
      talker.error('Firestore Error adding customer: ${e.message}', e, s);
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to add customer.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error adding customer: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error adding customer');
      return Left(
        UnknownFailure(message: 'Failed to add customer: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(String id) async {
    try {
      await remoteDatasource.deleteCustomer(id);
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error('Firestore Error deleting customer: ${e.message}', e, s);
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to delete customer.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error deleting customer: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error deleting customer');
      return Left(
        UnknownFailure(message: 'Failed to delete customer: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomerPhoto({
    required String customerId,
  }) async {
    try {
      final customerModel = await remoteDatasource.getCustomerById(customerId);
      final existingPhotoUrl = customerModel?.photoUrl;

      await remoteDatasource.deleteCustomerPhoto(customerId: customerId);

      if (existingPhotoUrl != null && existingPhotoUrl.isNotEmpty) {
        talker.info('TODO: Delete file from storage: $existingPhotoUrl');
      }
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error deleting customer photo: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to delete customer photo.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error deleting customer photo: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error deleting customer photo');
      return Left(
        UnknownFailure(
          message: 'Failed to delete customer photo: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CustomerEntity>> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
  }) async {
    try {
      final customerModel = await remoteDatasource.findOrCreateCustomer(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        email: email,
        photoUrl: photoUrl,
        recordedByUid: recordedByUid,
        createdAt: DateTime.now(),
      );
      return Right(customerModel.toEntity());
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error finding/creating customer: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to find or create customer.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error(
        'Network Error finding/creating customer: ${e.message}',
        e,
        s,
      );
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error finding/creating customer');
      return Left(
        UnknownFailure(
          message: 'Failed to find or create customer: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, CustomerEntity?>> findCustomerByPhoneNumber(
    String phoneNumber,
  ) async {
    try {
      final customerModel = await remoteDatasource.findCustomerByPhoneNumber(
        phoneNumber,
      );
      return Right(customerModel?.toEntity());
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error finding customer by phone: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to find customer by phone.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error(
        'Network Error finding customer by phone: ${e.message}',
        e,
        s,
      );
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error finding customer by phone');
      return Left(
        UnknownFailure(
          message: 'Failed to find customer by phone: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> getAllCustomers({
    String? searchQuery,
  }) async {
    try {
      final customerModels = await remoteDatasource.getAllCustomers(
        searchQuery: searchQuery,
      );
      return Right(customerModels.map((model) => model.toEntity()).toList());
    } on FirebaseException catch (e, s) {
      talker.error('Firestore Error getting all customers: ${e.message}', e, s);
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to get all customers.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error getting all customers: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error getting all customers');
      return Left(
        UnknownFailure(message: 'Failed to get all customers: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, CustomerEntity?>> getCustomerById(String id) async {
    try {
      final customerModel = await remoteDatasource.getCustomerById(id);
      return Right(customerModel?.toEntity());
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error getting customer by ID: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to get customer by ID.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error getting customer by ID: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error getting customer by ID');
      return Left(
        UnknownFailure(
          message: 'Failed to get customer by ID: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomer(
    CustomerEntity customerData,
  ) async {
    try {
      final now = DateTime.now();
      final customerModel = CustomerModel.fromEntity(
        customerData.copyWith(updatedAt: now),
      );
      await remoteDatasource.updateCustomer(customerModel);
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error('Firestore Error updating customer: ${e.message}', e, s);
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to update customer.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error updating customer: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error updating customer');
      return Left(
        UnknownFailure(message: 'Failed to update customer: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomerPhotoUrl({
    required String customerId,
    required String? photoUrl,
  }) async {
    try {
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
        talker.info('TODO: Delete file from storage: $oldPhotoUrl');
      }
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error updating customer photo URL: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to update customer photo URL.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error(
        'Network Error updating customer photo URL: ${e.message}',
        e,
        s,
      );
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error updating customer photo URL');
      return Left(
        UnknownFailure(
          message: 'Failed to update customer photo URL: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  }) async {
    try {
      await remoteDatasource.updateCustomerPurchaseStats(
        customerId: customerId,
        saleAmount: saleAmount,
        purchaseDate: purchaseDate,
      );
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error updating customer purchase stats: ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to update customer purchase stats.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error(
        'Network Error updating customer purchase stats: ${e.message}',
        e,
        s,
      );
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error updating customer purchase stats');
      return Left(
        UnknownFailure(
          message: 'Failed to update customer purchase stats: ${e.toString()}',
        ),
      );
    }
  }
}

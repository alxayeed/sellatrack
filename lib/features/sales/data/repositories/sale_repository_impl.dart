import 'dart:io'; // For SocketException

import 'package:cloud_firestore/cloud_firestore.dart'; // For FirebaseException
import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/core/logging/talker.dart';
import 'package:sellatrack/features/sales/data/datasources/sale_remote_datasource.dart';
import 'package:sellatrack/features/sales/data/models/sale_model.dart';
import 'package:sellatrack/features/sales/domain/entities/sale_entity.dart';
import 'package:sellatrack/features/sales/domain/repositories/sale_repository.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDatasource remoteDatasource;

  // final NetworkInfo networkInfo; // Optional for checking connectivity

  SaleRepositoryImpl({
    required this.remoteDatasource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> addSale(SaleEntity saleData) async {
    // if (await networkInfo.isConnected == false) {
    //   return Left(NetworkFailure(message: "No internet connection."));
    // }
    try {
      // The SaleEntity from domain might not have ID or system timestamps yet.
      // The SaleModel.fromEntity will handle this, and the datasource's toFirestoreMap
      // should omit ID if it's auto-generated, and set server timestamps for createdAt.
      // The repository is a good place to ensure `recordedBy` and `createdAt` are set if not already.
      final saleModel = SaleModel.fromEntity(
        saleData.copyWith(
          // ID might be empty or placeholder from use case/notifier
          // createdAt and recordedBy should be set before this point or handled by model/datasource
          // If `saleData` from usecase doesn't have these, they need to be added.
          // For example, use case should add `recordedBy` from current auth user.
        ),
      );
      final saleId = await remoteDatasource.addSale(saleModel);
      return Right(saleId);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error adding sale: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to record sale.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error adding sale: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error adding sale');
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while recording the sale.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<SaleEntity>>> getAllSales({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final saleModels = await remoteDatasource.getAllSales(
        customerId: customerId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(saleModels.map((model) => model.toEntity()).toList());
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error getting sales: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to retrieve sales data.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error getting sales: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error getting sales');
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while fetching sales.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SaleEntity?>> getSaleById(String id) async {
    try {
      final saleModel = await remoteDatasource.getSaleById(id);
      return Right(saleModel?.toEntity());
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error getting sale by ID: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to retrieve sale details.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error getting sale by ID: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error getting sale by ID');
      return Left(
        UnknownFailure(
          message: 'An unexpected error occurred while fetching sale details.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> hardDeleteSale(String saleId) async {
    try {
      await remoteDatasource.hardDeleteSale(saleId);
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error hard deleting sale: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(
          message: e.message ?? 'Failed to permanently delete sale.',
        ),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error hard deleting sale: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error hard deleting sale');
      return Left(UnknownFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> restoreSale(String saleId) async {
    try {
      await remoteDatasource.restoreSale(saleId);
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error restoring sale: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to restore sale.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error restoring sale: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error restoring sale');
      return Left(UnknownFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteSale({
    required String saleId,
    required String deletedByUid,
  }) async {
    try {
      await remoteDatasource.softDeleteSale(
        saleId: saleId,
        deletedByUid: deletedByUid,
        deletedAt: DateTime.now(),
      );
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error soft deleting sale: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to delete sale.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error soft deleting sale: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error soft deleting sale');
      return Left(UnknownFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSale(SaleEntity saleData) async {
    try {
      final saleModel = SaleModel.fromEntity(
        saleData.copyWith(
          updatedAt: DateTime.now(),
          // lastUpdatedBy should be set by the use case or notifier, based on current app user
        ),
      );
      await remoteDatasource.updateSale(saleModel);
      return const Right(null);
    } on FirebaseException catch (e, s) {
      talker.error(
        'Firestore Error updating sale: ${e.code} - ${e.message}',
        e,
        s,
      );
      return Left(
        FirestoreFailure(message: e.message ?? 'Failed to update sale.'),
      );
    } on SocketException catch (e, s) {
      talker.error('Network Error updating sale: ${e.message}', e, s);
      return Left(
        NetworkFailure(message: 'Network error. Please check your connection.'),
      );
    } catch (e, s) {
      talker.handle(e, s, 'Unexpected error updating sale');
      return Left(UnknownFailure(message: 'An unexpected error occurred.'));
    }
  }
}

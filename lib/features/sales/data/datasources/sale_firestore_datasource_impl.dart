import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/sales/data/datasources/sale_remote_datasource.dart';
import 'package:sellatrack/features/sales/data/models/sale_model.dart';

import '../../../../core/di/providers.dart';

class SaleRemoteDatasourceImpl implements SaleRemoteDatasource {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  String get _collectionPath =>
      _ref.read(appConfigProvider).collectionName('sales');

  SaleRemoteDatasourceImpl(this._firestore, this._ref);

  @override
  Future<String> addSale(SaleModel saleModel) async {
    try {
      final docRef = await _firestore
          .collection(_collectionPath)
          .add(saleModel.toFirestoreMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error adding sale to Firestore: ${e.toString()}');
    }
  }

  @override
  Future<List<SaleModel>> getAllSales({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore.collection(_collectionPath);

      if (customerId != null && customerId.isNotEmpty) {
        query = query.where('customerId', isEqualTo: customerId);
      }
      if (startDate != null) {
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        // For endDate, to include the whole day, you might want to adjust it
        // to the end of that day, e.g., DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59)
        query = query.where(
          'date',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

      // Default filter: exclude soft-deleted items
      query = query.where('isDeleted', isEqualTo: false);
      query = query.orderBy('date', descending: true);

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map(
            (doc) => SaleModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Error getting all sales from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<SaleModel?> getSaleById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionPath).doc(id).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final sale = SaleModel.fromFirestore(docSnapshot);
        // Exclude if soft-deleted, unless explicitly requested otherwise (not a param here)
        return sale.isDeleted ? null : sale;
      }
      return null;
    } catch (e) {
      throw Exception(
        'Error getting sale by ID from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> hardDeleteSale(String saleId) async {
    try {
      await _firestore.collection(_collectionPath).doc(saleId).delete();
    } catch (e) {
      throw Exception(
        'Error hard deleting sale from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> restoreSale(String saleId) async {
    try {
      await _firestore.collection(_collectionPath).doc(saleId).update({
        'isDeleted': false,
        'deletedAt': FieldValue.delete(),
        'lastUpdatedBy': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error restoring sale in Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> softDeleteSale({
    required String saleId,
    required String deletedByUid,
    required DateTime deletedAt,
  }) async {
    try {
      await _firestore.collection(_collectionPath).doc(saleId).update({
        'isDeleted': true,
        'deletedAt': Timestamp.fromDate(deletedAt),
        'lastUpdatedBy': deletedByUid,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error soft deleting sale in Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> updateSale(SaleModel saleModel) async {
    try {
      Map<String, dynamic> updateData = saleModel.toFirestoreMap();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(_collectionPath)
          .doc(saleModel.id)
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating sale in Firestore: ${e.toString()}');
    }
  }
}

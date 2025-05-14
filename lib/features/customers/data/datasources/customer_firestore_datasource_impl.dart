import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellatrack/features/customers/data/datasources/customer_remote_datasource.dart';
import 'package:sellatrack/features/customers/data/models/customer_model.dart';

class CustomerFirestoreDatasourceImpl implements CustomerRemoteDatasource {
  final FirebaseFirestore _firestore;
  static const String _collectionPath = 'customers';

  CustomerFirestoreDatasourceImpl(this._firestore);

  @override
  Future<String> addCustomer(CustomerModel customerModel) async {
    try {
      final docRef = await _firestore
          .collection(_collectionPath)
          .add(customerModel.toFirestoreMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error adding customer to Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception(
        'Error deleting customer from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteCustomerPhoto({required String customerId}) async {
    try {
      await _firestore.collection(_collectionPath).doc(customerId).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(
        'Error deleting customer photo from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<CustomerModel> findOrCreateCustomer({
    required String name,
    required String phoneNumber,
    required String address,
    String? email,
    String? photoUrl,
    required String recordedByUid,
    required DateTime createdAt,
  }) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionPath)
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        final existingDoc = querySnapshot.docs.first;
        return CustomerModel.fromFirestore(
          existingDoc as DocumentSnapshot<Map<String, dynamic>>,
        );
      } else {
        final newCustomer = CustomerModel(
          id: '',
          name: name,
          phoneNumber: phoneNumber,
          address: address,
          email: email,
          photoUrl: photoUrl,
          createdAt: createdAt,
          recordedBy: recordedByUid,
          updatedAt: createdAt,
          lastUpdatedBy: recordedByUid,
        );
        final docRef = await _firestore
            .collection(_collectionPath)
            .add(newCustomer.toFirestoreMap());

        return CustomerModel(
          id: docRef.id,
          name: newCustomer.name,
          phoneNumber: newCustomer.phoneNumber,
          address: newCustomer.address,
          email: newCustomer.email,
          photoUrl: newCustomer.photoUrl,
          createdAt: newCustomer.createdAt,
          updatedAt: newCustomer.updatedAt,
          recordedBy: newCustomer.recordedBy,
          lastUpdatedBy: newCustomer.lastUpdatedBy,
          firstPurchaseDate: newCustomer.firstPurchaseDate,
          lastPurchaseDate: newCustomer.lastPurchaseDate,
          totalOrders: newCustomer.totalOrders,
          totalSpent: newCustomer.totalSpent,
          notes: newCustomer.notes,
        );
      }
    } catch (e) {
      throw Exception(
        'Error finding or creating customer in Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<CustomerModel?> findCustomerByPhoneNumber(String phoneNumber) async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_collectionPath)
              .where('phoneNumber', isEqualTo: phoneNumber)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CustomerModel.fromFirestore(
          querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>,
        );
      }
      return null;
    } catch (e) {
      throw Exception(
        'Error finding customer by phone number in Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<CustomerModel>> getAllCustomers({String? searchQuery}) async {
    try {
      Query query = _firestore.collection(_collectionPath).orderBy('name');
      // Basic search: case-insensitive prefix search on 'name'
      // Firestore is limited in complex text search; for advanced search, consider Algolia/Typesense.
      if (searchQuery != null && searchQuery.isNotEmpty) {
        // A simple prefix search:
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery)
            .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff');
      }
      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map(
            (doc) => CustomerModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Error getting all customers from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<CustomerModel?> getCustomerById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection(_collectionPath).doc(id).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return CustomerModel.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      throw Exception(
        'Error getting customer by ID from Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateCustomer(CustomerModel customerModel) async {
    try {
      Map<String, dynamic> updateData = customerModel.toFirestoreMap();
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      // lastUpdatedBy should also be updated here, assuming it's part of the model passed
      if (customerModel.lastUpdatedBy != null) {
        updateData['lastUpdatedBy'] = customerModel.lastUpdatedBy;
      }

      await _firestore
          .collection(_collectionPath)
          .doc(customerModel.id)
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating customer in Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCustomerPhotoUrl({
    required String customerId,
    required String? photoUrl,
  }) async {
    try {
      await _firestore.collection(_collectionPath).doc(customerId).update({
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        // 'lastUpdatedBy': /* current app user UID */ // Should also be updated
      });
    } catch (e) {
      throw Exception(
        'Error updating customer photo URL in Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> updateCustomerPurchaseStats({
    required String customerId,
    required double saleAmount,
    required DateTime purchaseDate,
  }) async {
    try {
      final customerRef = _firestore
          .collection(_collectionPath)
          .doc(customerId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(customerRef);
        if (!snapshot.exists) {
          throw Exception("Customer with ID $customerId does not exist.");
        }
        final currentModel = CustomerModel.fromFirestore(snapshot);

        int newTotalOrders = currentModel.totalOrders + 1;
        double newTotalSpent = currentModel.totalSpent + saleAmount;
        DateTime newLastPurchaseDate = purchaseDate;
        DateTime? newFirstPurchaseDate =
            currentModel.firstPurchaseDate ?? purchaseDate;

        transaction.update(customerRef, {
          'totalOrders': newTotalOrders,
          'totalSpent': newTotalSpent,
          'lastPurchaseDate': Timestamp.fromDate(newLastPurchaseDate),
          'firstPurchaseDate': Timestamp.fromDate(newFirstPurchaseDate),
          'updatedAt': FieldValue.serverTimestamp(),
          // 'lastUpdatedBy': /* current app user UID */ // Should also be updated
        });
      });
    } catch (e) {
      throw Exception(
        'Error updating customer purchase stats in Firestore: ${e.toString()}',
      );
    }
  }
}

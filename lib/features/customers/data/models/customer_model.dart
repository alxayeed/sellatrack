import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.address,
    super.email,
    super.photoUrl,
    required super.createdAt,
    super.updatedAt,
    super.recordedBy,
    super.lastUpdatedBy,
    super.firstPurchaseDate,
    super.lastPurchaseDate,
    super.totalOrders = 0,
    super.totalSpent = 0.0,
    super.notes,
  });

  factory CustomerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw Exception("Customer document data is null!");
    }
    return CustomerModel(
      id: doc.id,
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as String,
      address: data['address'] as String,
      email: data['email'] as String?,
      photoUrl: data['photoUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      recordedBy: data['recordedBy'] as String?,
      lastUpdatedBy: data['lastUpdatedBy'] as String?,
      firstPurchaseDate: (data['firstPurchaseDate'] as Timestamp?)?.toDate(),
      lastPurchaseDate: (data['lastPurchaseDate'] as Timestamp?)?.toDate(),
      totalOrders: (data['totalOrders'] as num?)?.toInt() ?? 0,
      totalSpent: (data['totalSpent'] as num?)?.toDouble() ?? 0.0,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'recordedBy': recordedBy,
      'lastUpdatedBy': lastUpdatedBy,
      'firstPurchaseDate':
          firstPurchaseDate == null
              ? null
              : Timestamp.fromDate(firstPurchaseDate!),
      'lastPurchaseDate':
          lastPurchaseDate == null
              ? null
              : Timestamp.fromDate(lastPurchaseDate!),
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'notes': notes,
    };
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      email: entity.email,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      recordedBy: entity.recordedBy,
      lastUpdatedBy: entity.lastUpdatedBy,
      firstPurchaseDate: entity.firstPurchaseDate,
      lastPurchaseDate: entity.lastPurchaseDate,
      totalOrders: entity.totalOrders,
      totalSpent: entity.totalSpent,
      notes: entity.notes,
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
      photoUrl: photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      recordedBy: recordedBy,
      lastUpdatedBy: lastUpdatedBy,
      firstPurchaseDate: firstPurchaseDate,
      lastPurchaseDate: lastPurchaseDate,
      totalOrders: totalOrders,
      totalSpent: totalSpent,
      notes: notes,
    );
  }
}

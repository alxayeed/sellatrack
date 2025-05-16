import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final String? email;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? recordedBy;
  final String? lastUpdatedBy;
  final DateTime? firstPurchaseDate;
  final DateTime? lastPurchaseDate;
  final int totalOrders;
  final double totalSpent;
  final String? notes;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.email,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.recordedBy,
    this.lastUpdatedBy,
    this.firstPurchaseDate,
    this.lastPurchaseDate,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.notes,
  });

  CustomerEntity copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? address,
    String? email,
    bool clearEmail = false,
    String? photoUrl,
    bool clearPhotoUrl = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearUpdatedAt = false,
    String? recordedBy,
    bool clearRecordedBy = false,
    String? lastUpdatedBy,
    bool clearLastUpdatedBy = false,
    DateTime? firstPurchaseDate,
    bool clearFirstPurchaseDate = false,
    DateTime? lastPurchaseDate,
    bool clearLastPurchaseDate = false,
    int? totalOrders,
    double? totalSpent,
    String? notes,
    bool clearNotes = false,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: clearEmail ? null : email ?? this.email,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: clearUpdatedAt ? null : updatedAt ?? this.updatedAt,
      recordedBy: clearRecordedBy ? null : recordedBy ?? this.recordedBy,
      lastUpdatedBy:
          clearLastUpdatedBy ? null : lastUpdatedBy ?? this.lastUpdatedBy,
      firstPurchaseDate:
          clearFirstPurchaseDate
              ? null
              : firstPurchaseDate ?? this.firstPurchaseDate,
      lastPurchaseDate:
          clearLastPurchaseDate
              ? null
              : lastPurchaseDate ?? this.lastPurchaseDate,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      notes: clearNotes ? null : notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    address,
    email,
    photoUrl,
    createdAt,
    updatedAt,
    recordedBy,
    lastUpdatedBy,
    firstPurchaseDate,
    lastPurchaseDate,
    totalOrders,
    totalSpent,
    notes,
  ];

  @override
  bool get stringify => true;
}

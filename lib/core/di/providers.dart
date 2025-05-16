import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:sellatrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_in_with_email_password_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_up_with_email_password_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:sellatrack/features/customers/data/datasources/customer_firestore_datasource_impl.dart';
import 'package:sellatrack/features/customers/data/datasources/customer_remote_datasource.dart';
import 'package:sellatrack/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';
import 'package:sellatrack/features/customers/domain/usecases/add_customer_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/delete_customer_photo_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/delete_customer_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/find_customer_by_phone_number_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/find_or_create_customer_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/get_all_customers_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/get_customer_by_id_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/update_customer_photo_url_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/update_customer_purchase_stats_usecase.dart';
import 'package:sellatrack/features/customers/domain/usecases/update_customer_usecase.dart';

import '../errors/error_handler_service.dart';

// --- CORE SERVICE PROVIDERS ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final errorHandlerServiceProvider = Provider<ErrorHandlerService>((ref) {
  return const ErrorHandlerService();
});

// --- AUTH FEATURE DATASOURCE PROVIDERS ---
final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDatasourceImpl(firebaseAuth);
});

// --- AUTH FEATURE REPOSITORY PROVIDERS ---
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(firebaseAuthDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// --- AUTH FEATURE USECASE PROVIDERS ---
final getAuthStateChangesUseCaseProvider = Provider<GetAuthStateChangesUseCase>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return GetAuthStateChangesUseCase(repository);
  },
);

final signUpWithEmailPasswordUseCaseProvider =
    Provider<SignUpWithEmailPasswordUseCase>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return SignUpWithEmailPasswordUseCase(repository);
    });

final signInWithEmailPasswordUseCaseProvider =
    Provider<SignInWithEmailPasswordUseCase>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return SignInWithEmailPasswordUseCase(repository);
    });

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repository);
});

// final sendPasswordResetEmailUseCaseProvider =
// Provider<SendPasswordResetEmailUseCase>((ref) {
//   final repository = ref.watch(authRepositoryProvider);
//   return SendPasswordResetEmailUseCase(repository);
// });

// --- CUSTOMER FEATURE DATASOURCE PROVIDERS ---
final customerRemoteDatasourceProvider = Provider<CustomerRemoteDatasource>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return CustomerFirestoreDatasourceImpl(firestore);
});

// --- CUSTOMER FEATURE REPOSITORY PROVIDERS ---
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final remoteDatasource = ref.watch(customerRemoteDatasourceProvider);
  return CustomerRepositoryImpl(remoteDatasource: remoteDatasource);
});

// --- CUSTOMER FEATURE USECASE PROVIDERS ---
final getCustomerByIdUseCaseProvider = Provider<GetCustomerByIdUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return GetCustomerByIdUseCase(repository);
});

final getAllCustomersUseCaseProvider = Provider<GetAllCustomersUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return GetAllCustomersUseCase(repository);
});

final findCustomerByPhoneNumberUseCaseProvider =
    Provider<FindCustomerByPhoneNumberUseCase>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return FindCustomerByPhoneNumberUseCase(repository);
    });

final addCustomerUseCaseProvider = Provider<AddCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return AddCustomerUseCase(repository);
});

final findOrCreateCustomerUseCaseProvider =
    Provider<FindOrCreateCustomerUseCase>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return FindOrCreateCustomerUseCase(repository);
    });

final updateCustomerUseCaseProvider = Provider<UpdateCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return UpdateCustomerUseCase(repository);
});

final deleteCustomerUseCaseProvider = Provider<DeleteCustomerUseCase>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  return DeleteCustomerUseCase(repository);
});

final updateCustomerPhotoUrlUseCaseProvider =
    Provider<UpdateCustomerPhotoUrlUseCase>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return UpdateCustomerPhotoUrlUseCase(repository);
    });

final deleteCustomerPhotoUseCaseProvider = Provider<DeleteCustomerPhotoUseCase>(
  (ref) {
    final repository = ref.watch(customerRepositoryProvider);
    return DeleteCustomerPhotoUseCase(repository);
  },
);

final updateCustomerPurchaseStatsUseCaseProvider =
    Provider<UpdateCustomerPurchaseStatsUseCase>((ref) {
      final repository = ref.watch(customerRepositoryProvider);
      return UpdateCustomerPurchaseStatsUseCase(repository);
    });

// --- APP STATE PROVIDERS (or Auth State Providers) ---
final authStateChangesProvider = StreamProvider<AuthUserEntity?>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges.call();
});

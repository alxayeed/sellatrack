import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellatrack/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/usecases.dart';

import '../../features/auth/data/datasources/firebase_auth_datasource.dart';
import '../../features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/entities/auth_user_entity.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/customers/data/datasources/customer_firestore_datasource_impl.dart';
import '../../features/customers/data/datasources/customer_remote_datasource.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/domain/usecases/usecases.dart';
import '../../features/sales/data/datasources/sale_firestore_datasource_impl.dart';
import '../../features/sales/data/datasources/sale_remote_datasource.dart';
import '../../features/sales/data/repositories/sale_repository_impl.dart';
import '../../features/sales/domain/repositories/sale_repository.dart';
import '../../features/sales/domain/usecases/usecases.dart';
import '../config/app_config.dart';
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

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig not initialized!');
});

// --- DATASOURCE PROVIDERS ---
// Auth
final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDatasourceImpl(firebaseAuth);
});
// Customer
final customerRemoteDatasourceProvider = Provider<CustomerRemoteDatasource>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return CustomerFirestoreDatasourceImpl(firestore, ref);
});
// Sale
final saleRemoteDatasourceProvider = Provider<SaleRemoteDatasource>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return SaleRemoteDatasourceImpl(firestore, ref);
});

// --- REPOSITORY PROVIDERS ---
// Auth
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(firebaseAuthDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});
// Customer
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final remoteDatasource = ref.watch(customerRemoteDatasourceProvider);
  return CustomerRepositoryImpl(remoteDatasource: remoteDatasource);
});
// Sale
final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  final remoteDatasource = ref.watch(saleRemoteDatasourceProvider);
  return SaleRepositoryImpl(remoteDatasource: remoteDatasource);
});

// --- USECASE PROVIDERS ---
// Auth
final getAuthStateChangesUseCaseProvider = Provider<GetAuthStateChangesUseCase>(
  (ref) => GetAuthStateChangesUseCase(ref.watch(authRepositoryProvider)),
);
final signUpWithEmailPasswordUseCaseProvider = Provider<
  SignUpWithEmailPasswordUseCase
>((ref) => SignUpWithEmailPasswordUseCase(ref.watch(authRepositoryProvider)));
final signInWithEmailPasswordUseCaseProvider = Provider<
  SignInWithEmailPasswordUseCase
>((ref) => SignInWithEmailPasswordUseCase(ref.watch(authRepositoryProvider)));
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>(
  (ref) => UpdateUserProfileUseCase(ref.watch(authRepositoryProvider)),
);
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);
final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>(
  (ref) => ResetPasswordUseCase(ref.watch(authRepositoryProvider)),
);

// Customer
final getCustomerByIdUseCaseProvider = Provider<GetCustomerByIdUseCase>(
  (ref) => GetCustomerByIdUseCase(ref.watch(customerRepositoryProvider)),
);
final getAllCustomersUseCaseProvider = Provider<GetAllCustomersUseCase>(
  (ref) => GetAllCustomersUseCase(ref.watch(customerRepositoryProvider)),
);
final findCustomerByPhoneNumberUseCaseProvider =
    Provider<FindCustomerByPhoneNumberUseCase>(
      (ref) => FindCustomerByPhoneNumberUseCase(
        ref.watch(customerRepositoryProvider),
      ),
    );
final addCustomerUseCaseProvider = Provider<AddCustomerUseCase>(
  (ref) => AddCustomerUseCase(ref.watch(customerRepositoryProvider)),
);
final findOrCreateCustomerUseCaseProvider = Provider<
  FindOrCreateCustomerUseCase
>((ref) => FindOrCreateCustomerUseCase(ref.watch(customerRepositoryProvider)));
final updateCustomerUseCaseProvider = Provider<UpdateCustomerUseCase>(
  (ref) => UpdateCustomerUseCase(ref.watch(customerRepositoryProvider)),
);
final deleteCustomerUseCaseProvider = Provider<DeleteCustomerUseCase>(
  (ref) => DeleteCustomerUseCase(ref.watch(customerRepositoryProvider)),
);
final updateCustomerPhotoUrlUseCaseProvider =
    Provider<UpdateCustomerPhotoUrlUseCase>(
      (ref) =>
          UpdateCustomerPhotoUrlUseCase(ref.watch(customerRepositoryProvider)),
    );
final deleteCustomerPhotoUseCaseProvider = Provider<DeleteCustomerPhotoUseCase>(
  (ref) => DeleteCustomerPhotoUseCase(ref.watch(customerRepositoryProvider)),
);
final updateCustomerPurchaseStatsUseCaseProvider =
    Provider<UpdateCustomerPurchaseStatsUseCase>(
      (ref) => UpdateCustomerPurchaseStatsUseCase(
        ref.watch(customerRepositoryProvider),
      ),
    );

// Sale
final getSaleByIdUseCaseProvider = Provider<GetSaleByIdUseCase>(
  (ref) => GetSaleByIdUseCase(ref.watch(saleRepositoryProvider)),
);
final getAllSalesUseCaseProvider = Provider<GetAllSalesUseCase>(
  (ref) => GetAllSalesUseCase(ref.watch(saleRepositoryProvider)),
);
final addSaleUseCaseProvider = Provider<AddSaleUseCase>((ref) {
  return AddSaleUseCase(
    saleRepository: ref.watch(saleRepositoryProvider),
    findOrCreateCustomerUseCase: ref.watch(findOrCreateCustomerUseCaseProvider),
    updateCustomerPurchaseStatsUseCase: ref.watch(
      updateCustomerPurchaseStatsUseCaseProvider,
    ),
  );
});
final updateSaleUseCaseProvider = Provider<UpdateSaleUseCase>(
  (ref) => UpdateSaleUseCase(ref.watch(saleRepositoryProvider)),
);
final softDeleteSaleUseCaseProvider = Provider<SoftDeleteSaleUseCase>(
  (ref) => SoftDeleteSaleUseCase(ref.watch(saleRepositoryProvider)),
);
final restoreSaleUseCaseProvider = Provider<RestoreSaleUseCase>(
  (ref) => RestoreSaleUseCase(ref.watch(saleRepositoryProvider)),
);
final hardDeleteSaleUseCaseProvider = Provider<HardDeleteSaleUseCase>(
  (ref) => HardDeleteSaleUseCase(ref.watch(saleRepositoryProvider)),
);

// --- APP STATE PROVIDERS ---
final authStateChangesProvider = StreamProvider<AuthUserEntity?>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges.call();
});

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Auth Feature Specific Imports
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource_impl.dart';
import 'package:sellatrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_auth_state_changes_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_in_with_otp_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:sellatrack/features/auth/domain/usecases/verify_phone_number_usecase.dart';

// --- CORE SERVICE PROVIDERS ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
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

final verifyPhoneNumberUseCaseProvider = Provider<VerifyPhoneNumberUseCase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyPhoneNumberUseCase(repository);
});

final signInWithOtpUseCaseProvider = Provider<SignInWithOtpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithOtpUseCase(repository);
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

// --- Other feature providers would go below, or in separate files within core/di/ ---
// e.g., Sales Providers, Expense Providers

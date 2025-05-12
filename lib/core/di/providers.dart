import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Auth Feature Specific Imports
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

// Optional:
// final sendCurrentUserEmailVerificationUseCaseProvider = Provider<SendCurrentUserEmailVerificationUseCase>(
//   (ref) {
//     final repository = ref.watch(authRepositoryProvider);
//     return SendCurrentUserEmailVerificationUseCase(repository);
//   },
// );

// --- APP STATE PROVIDERS (or Auth State Providers) ---
final authStateChangesProvider = StreamProvider<AuthUserEntity?>((ref) {
  final getAuthStateChanges = ref.watch(getAuthStateChangesUseCaseProvider);
  return getAuthStateChanges.call();
});

// --- Other feature providers would go below, or in separate files within core/di/ ---

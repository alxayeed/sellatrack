import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Stream<AuthUserEntity?> get authStateChanges;

  Future<AuthUserEntity?> signUpWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthUserEntity?> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  });

  Future<AuthUserEntity?> getCurrentUser();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});
}

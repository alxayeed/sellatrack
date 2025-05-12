import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:sellatrack/features/auth/data/models/auth_user_model.dart';
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource firebaseAuthDatasource;

  AuthRepositoryImpl(this.firebaseAuthDatasource);

  @override
  Stream<AuthUserEntity?> get authStateChanges {
    return firebaseAuthDatasource.firebaseAuthStateChanges.map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser).toEntity();
    });
  }

  @override
  Future<AuthUserEntity?> getCurrentUser() async {
    try {
      final firebaseUser =
          await firebaseAuthDatasource.getCurrentFirebaseUser();
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser).toEntity();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthUserEntity?> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = await firebaseAuthDatasource
          .signUpWithEmailPasswordWithFirebase(
            email: email,
            password: password,
          );
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser).toEntity();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthUserEntity?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = await firebaseAuthDatasource
          .signInWithEmailPasswordWithFirebase(
            email: email,
            password: password,
          );
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser).toEntity();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuthDatasource.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  }) async {
    try {
      await firebaseAuthDatasource.updateUserProfile(
        displayName: displayName,
        email: email,
        photoURL: photoURL,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await firebaseAuthDatasource.sendPasswordResetEmailWithFirebase(
        email: email,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}

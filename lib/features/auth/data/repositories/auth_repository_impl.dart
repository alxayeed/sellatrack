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
  Future<AuthUserEntity?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final firebaseUser = await firebaseAuthDatasource.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
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
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(AuthUserEntity authUserEntity) verificationCompleted,
    required void Function(String error) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return firebaseAuthDatasource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      verificationCompleted: (firebase_auth.User firebaseUser) {
        verificationCompleted(
          AuthUserModel.fromFirebaseAuthUser(firebaseUser).toEntity(),
        );
      },
      verificationFailed: (firebase_auth.FirebaseAuthException exception) {
        verificationFailed(exception.message ?? 'Unknown verification error');
      },
      timeout: timeout,
    );
  }
}

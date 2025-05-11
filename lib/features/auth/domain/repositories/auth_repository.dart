import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Stream<AuthUserEntity?> get authStateChanges;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(AuthUserEntity authUserEntity) verificationCompleted,
    required void Function(String error) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  });

  Future<AuthUserEntity?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  });

  Future<AuthUserEntity?> getCurrentUser();

  Future<void> signOut();
}

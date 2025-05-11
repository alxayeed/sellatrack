import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sellatrack/features/auth/data/datasources/firebase_auth_datasource.dart';

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthDatasourceImpl(this._firebaseAuth);

  @override
  Stream<firebase_auth.User?> get firebaseAuthStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<firebase_auth.User?> getCurrentFirebaseUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<firebase_auth.User?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = firebase_auth.PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  }) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User not signed in.');
    }

    if (displayName != null) {
      await currentUser.updateDisplayName(displayName);
    }
    if (email != null) {
      await currentUser.verifyBeforeUpdateEmail(email);
    }
    if (photoURL != null) {
      await currentUser.updatePhotoURL(photoURL);
    }
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(firebase_auth.User firebaseUser)
    verificationCompleted,
    required void Function(firebase_auth.FirebaseAuthException exception)
    verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (
        firebase_auth.PhoneAuthCredential credential,
      ) async {
        try {
          final userCredential = await _firebaseAuth.signInWithCredential(
            credential,
          );
          if (userCredential.user != null) {
            verificationCompleted(userCredential.user!);
          } else {
            verificationFailed(
              firebase_auth.FirebaseAuthException(
                code: 'null-user-after-credential-signin',
                message:
                    'User was null after signing in with auto-retrieved credential.',
              ),
            );
          }
        } on firebase_auth.FirebaseAuthException catch (e) {
          verificationFailed(e);
        } catch (e) {
          verificationFailed(
            firebase_auth.FirebaseAuthException(
              code: 'unknown-error-during-auto-retrieval-signin',
              message: e.toString(),
            ),
          );
        }
      },
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: timeout,
    );
  }
}

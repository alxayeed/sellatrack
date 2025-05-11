import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class FirebaseAuthDatasource {
  Stream<firebase_auth.User?> get firebaseAuthStateChanges;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(firebase_auth.User firebaseUser)
    verificationCompleted, // Returns Firebase User
    required void Function(firebase_auth.FirebaseAuthException exception)
    verificationFailed, // Returns Firebase Exception
    Duration timeout = const Duration(seconds: 60),
  });

  Future<firebase_auth.User?> signInWithOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  });

  Future<firebase_auth.User?> getCurrentFirebaseUser();

  Future<void> signOut();
}

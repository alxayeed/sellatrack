import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class FirebaseAuthDatasource {
  Stream<firebase_auth.User?> get firebaseAuthStateChanges;

  Future<firebase_auth.User?> signUpWithEmailPasswordWithFirebase({
    required String email,
    required String password,
  });

  Future<firebase_auth.User?> signInWithEmailPasswordWithFirebase({
    required String email,
    required String password,
  });

  Future<void> updateUserProfile({
    String? displayName,
    String? email,
    String? photoURL,
  });

  Future<firebase_auth.User?> getCurrentFirebaseUser();

  Future<void> signOut();

  Future<void> sendPasswordResetEmailWithFirebase({required String email});
}

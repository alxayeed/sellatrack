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
  Future<firebase_auth.User?> signUpWithEmailPasswordWithFirebase({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<firebase_auth.User?> signInWithEmailPasswordWithFirebase({
    required String email,
    required String password,
  }) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
  Future<void> sendPasswordResetEmailWithFirebase({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

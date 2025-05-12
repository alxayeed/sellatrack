import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.uid,
    super.phoneNumber,
    super.email,
    super.displayName,
    super.photoURL,
  });

  factory AuthUserModel.fromFirebaseAuthUser(firebase_auth.User firebaseUser) {
    return AuthUserModel(
      uid: firebaseUser.uid,
      phoneNumber: firebaseUser.phoneNumber,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }

  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(
      uid: entity.uid,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
    );
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      uid: uid,
      phoneNumber: phoneNumber,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
    );
  }
}

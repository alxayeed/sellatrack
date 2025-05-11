import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String uid;
  final String? phoneNumber;
  final String? email;
  final String? displayName;
  final String? photoURL;

  const AuthUserEntity({
    required this.uid,
    this.phoneNumber,
    this.email,
    this.displayName,
    this.photoURL,
  });

  AuthUserEntity copyWith({
    String? uid,
    String? phoneNumber,
    String? email,
    String? displayName,
    String? photoURL,
  }) {
    return AuthUserEntity(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  @override
  List<Object?> get props => [uid, phoneNumber, email, displayName, photoURL];

  @override
  bool get stringify => true;
}

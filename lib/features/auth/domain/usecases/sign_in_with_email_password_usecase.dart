import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailPasswordUseCase(this.repository);

  Future<AuthUserEntity?> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty.');
    }
    return repository.signInWithEmailPassword(email: email, password: password);
  }
}

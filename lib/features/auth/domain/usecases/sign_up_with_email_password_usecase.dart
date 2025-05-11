import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmailPasswordUseCase {
  final AuthRepository repository;

  SignUpWithEmailPasswordUseCase(this.repository);

  Future<AuthUserEntity?> call({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty.');
    }
    // Add more sophisticated email/password validation if needed
    return repository.signUpWithEmailPassword(email: email, password: password);
  }
}

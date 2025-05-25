import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    return repository.sendPasswordResetEmail(email: email);
  }
}

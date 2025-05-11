import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class VerifyPhoneNumberUseCase {
  final AuthRepository repository;

  VerifyPhoneNumberUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
    required void Function(AuthUserEntity authUserEntity) verificationCompleted,
    required void Function(String error) verificationFailed,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      timeout: timeout,
    );
  }
}

import 'package:sellatrack/features/auth/domain/entities/auth_user_entity.dart';
import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class SignInWithOtpUseCase {
  final AuthRepository repository;

  SignInWithOtpUseCase(this.repository);

  Future<AuthUserEntity?> call({
    required String verificationId,
    required String smsCode,
  }) async {
    return repository.signInWithOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}

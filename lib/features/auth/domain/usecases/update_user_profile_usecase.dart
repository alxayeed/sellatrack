import 'package:sellatrack/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call({
    String? displayName,
    String? email,
    String? photoURL,
  }) async {
    if (displayName != null && displayName.isEmpty) {
      throw ArgumentError('Display name cannot be empty if provided.');
    }

    return repository.updateUserProfile(
      displayName: displayName,
      email: email,
      photoURL: photoURL,
    );
  }
}

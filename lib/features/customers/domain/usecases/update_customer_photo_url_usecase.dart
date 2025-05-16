import 'package:dartz/dartz.dart';
import 'package:sellatrack/core/errors/failures.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class UpdateCustomerPhotoUrlUseCase {
  final CustomerRepository repository;

  UpdateCustomerPhotoUrlUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String customerId,
    required String photoUrl,
  }) async {
    if (customerId.isEmpty) {
      return Left(InvalidInputFailure(message: 'Customer ID cannot be empty.'));
    }
    if (photoUrl.isEmpty) {
      return Left(
        InvalidInputFailure(
          message: 'Photo URL cannot be empty when updating.',
        ),
      );
    }
    return repository.updateCustomerPhotoUrl(
      customerId: customerId,
      photoUrl: photoUrl,
    );
  }
}

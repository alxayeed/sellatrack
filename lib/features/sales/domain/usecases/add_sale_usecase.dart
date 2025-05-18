import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/logging/talker.dart';
import '../../../customers/domain/usecases/find_or_create_customer_usecase.dart';
import '../../../customers/domain/usecases/update_customer_purchase_stats_usecase.dart';
import '../entities/sale_entity.dart';
import '../params/sale_input_data.dart';
import '../repositories/sale_repository.dart';

class AddSaleUseCase {
  final SaleRepository saleRepository;
  final FindOrCreateCustomerUseCase findOrCreateCustomerUseCase;
  final UpdateCustomerPurchaseStatsUseCase updateCustomerPurchaseStatsUseCase;

  AddSaleUseCase({
    required this.saleRepository,
    required this.findOrCreateCustomerUseCase,
    required this.updateCustomerPurchaseStatsUseCase,
  });

  Future<Either<Failure, String>> call(SaleInputData saleInput) async {
    // Validate inputs (basic) from saleInput
    if (saleInput.productName.isEmpty ||
        saleInput.quantity <= 0 ||
        saleInput.unit.isEmpty ||
        saleInput.saleAmount < 0) {
      return Left(
        InvalidInputFailure(
          message:
              'Product details, quantity, and amount are required and must be valid.',
        ),
      );
    }
    if (saleInput.customerNameForSale.isEmpty ||
        saleInput.customerPhoneForSale.isEmpty ||
        saleInput.customerAddressForSale.isEmpty) {
      return Left(
        InvalidInputFailure(
          message:
              'Customer name, phone, and address are required for the sale.',
        ),
      );
    }

    // Find or Create Customer
    final customerResult = await findOrCreateCustomerUseCase.call(
      name: saleInput.customerNameForSale,
      phoneNumber: saleInput.customerPhoneForSale,
      address: saleInput.customerAddressForSale,
      email: saleInput.customerEmailForSale,
      photoUrl: saleInput.customerPhotoUrlForSale,
      recordedByUid: saleInput.recordedByAppUserId,
    );

    return customerResult.fold(
      (failure) {
        talker.error(
          'AddSaleUseCase: Failed to find or create customer',
          failure,
        );
        return Left(failure);
      },
      (customerEntity) async {
        //Create SaleEntity from SaleInputData and customerEntity.id
        final saleData = SaleEntity(
          id: '',
          // Will be generated
          date: saleInput.saleDate,
          customerId: customerEntity.id,
          customerNameAtSale: saleInput.customerNameForSale,
          customerPhoneAtSale: saleInput.customerPhoneForSale,
          customerAddressAtSale: saleInput.customerAddressForSale,
          productDetails: ProductSoldDetails(
            productName: saleInput.productName,
            quantity: saleInput.quantity,
            unit: saleInput.unit,
            saleAmount: saleInput.saleAmount,
          ),
          totalSaleAmount: saleInput.saleAmount,
          paymentMethod: saleInput.paymentMethod,
          notes: saleInput.notes,
          recordedBy: saleInput.recordedByAppUserId,
          createdAt: DateTime.now(),
          lastUpdatedBy: saleInput.recordedByAppUserId,
          updatedAt: DateTime.now(),
          isDeleted: false,
        );

        // Add the Sale
        final addSaleResult = await saleRepository.addSale(saleData);

        return addSaleResult.fold(
          (failure) {
            talker.error('AddSaleUseCase: Failed to add sale', failure);
            return Left(failure);
          },
          (saleId) async {
            // Update Customer Purchase Stats
            final statsUpdateResult = await updateCustomerPurchaseStatsUseCase
                .call(
                  customerId: customerEntity.id,
                  saleAmount: saleInput.saleAmount,
                  purchaseDate: saleInput.saleDate,
                );

            statsUpdateResult.fold(
              (failure) {
                talker.warning(
                  'AddSaleUseCase: Sale $saleId recorded, but failed to update customer stats for ${customerEntity.id}',
                  failure,
                );
              },
              (_) => talker.info(
                'AddSaleUseCase: Customer stats updated for ${customerEntity.id} after sale $saleId',
              ),
            );
            return Right(saleId);
          },
        );
      },
    );
  }
}

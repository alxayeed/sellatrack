import 'package:sellatrack/features/sales/data/models/sale_model.dart';

abstract class SaleRemoteDatasource {
  Future<SaleModel?> getSaleById(String id);

  Future<List<SaleModel>> getAllSales({
    String? customerId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<String> addSale(SaleModel saleModel);

  Future<void> updateSale(SaleModel saleModel);

  Future<void> softDeleteSale({
    required String saleId,
    required String deletedByUid,
    required DateTime deletedAt,
  });

  Future<void> restoreSale(String saleId);

  Future<void> hardDeleteSale(String saleId);
}

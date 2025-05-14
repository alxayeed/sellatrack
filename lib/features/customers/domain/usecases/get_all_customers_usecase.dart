import 'package:sellatrack/features/customers/domain/entities/customer_entity.dart';
import 'package:sellatrack/features/customers/domain/repositories/customer_repository.dart';

class GetAllCustomersUseCase {
  final CustomerRepository repository;

  GetAllCustomersUseCase(this.repository);

  Future<List<CustomerEntity>> call({String? searchQuery}) async {
    return repository.getAllCustomers(searchQuery: searchQuery);
  }
}

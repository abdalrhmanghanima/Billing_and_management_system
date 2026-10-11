import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class GetTypes {
  const GetTypes(this.repository);

  final TypeRepository repository;

  Future<List<ItemType>> call() {
    return repository.getTypes();
  }
}

import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';
import 'package:billing_and_sales_management/domain/items/repositories/item_repository.dart';
import 'package:billing_and_sales_management/domain/types/repositories/type_repository.dart';

class DeleteCompany {
  const DeleteCompany(
    this.repository,
    this.typeRepository,
    this.itemRepository,
  );

  final CompanyRepository repository;
  final TypeRepository typeRepository;
  final ItemRepository itemRepository;

  Future<void> call(String id) async {
    final trimmedId = id.trim();
    if (trimmedId.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.notFound);
    }

    final types = await typeRepository.getTypes();
    final items = await itemRepository.getItems();

    final isReferenced =
        types.any((type) => type.companyId == trimmedId) ||
        items.any((item) => item.companyId == trimmedId);

    if (isReferenced) {
      throw const CompanyException(CompanyExceptionCodes.inUse);
    }

    return repository.deleteCompany(trimmedId);
  }
}

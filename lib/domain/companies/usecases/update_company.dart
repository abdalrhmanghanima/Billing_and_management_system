import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';

class UpdateCompany {
  const UpdateCompany(this.repository);

  final CompanyRepository repository;

  Future<void> call(String id, String name, String notes) {
    if (id.trim().isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.notFound);
    }

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.nameRequired);
    }

    return repository.updateCompany(
      Company(id: id.trim(), name: trimmedName, notes: notes.trim()),
    );
  }
}

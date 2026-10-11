import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';

class AddCompany {
  const AddCompany(this.repository);

  final CompanyRepository repository;

  Future<void> call(String name, String notes) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.nameRequired);
    }

    return repository.addCompany(
      Company(name: trimmedName, notes: notes.trim()),
    );
  }
}

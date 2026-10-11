import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';

class GetCompanies {
  const GetCompanies(this.repository);

  final CompanyRepository repository;

  Future<List<Company>> call() {
    return repository.getCompanies();
  }
}

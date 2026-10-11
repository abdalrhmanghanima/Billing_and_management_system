import 'package:billing_and_sales_management/domain/companies/entities/company.dart';

abstract interface class CompanyRepository {
  Future<List<Company>> getCompanies();

  Future<void> addCompany(Company company);

  Future<void> updateCompany(Company company);

  Future<void> deleteCompany(String id);
}

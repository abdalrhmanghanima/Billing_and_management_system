import 'package:billing_and_sales_management/data/companies/models/company_model.dart';

abstract interface class CompanyRemoteDataSource {
  Future<List<CompanyModel>> getCompanies();

  Future<void> addCompany(CompanyModel company);

  Future<void> updateCompany(CompanyModel company);

  Future<void> deleteCompany(String id);
}

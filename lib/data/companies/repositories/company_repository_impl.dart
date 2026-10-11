import 'package:billing_and_sales_management/data/companies/datasources/remote/company_remote_data_source.dart';
import 'package:billing_and_sales_management/data/companies/models/company_model.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRepositoryImpl(this._remoteDataSource);

  final CompanyRemoteDataSource _remoteDataSource;

  @override
  Future<List<Company>> getCompanies() {
    return _remoteDataSource.getCompanies();
  }

  @override
  Future<void> addCompany(Company company) {
    return _remoteDataSource.addCompany(CompanyModel.fromEntity(company));
  }
}

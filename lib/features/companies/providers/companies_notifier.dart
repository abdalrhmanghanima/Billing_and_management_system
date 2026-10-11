import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/data/companies/providers/company_providers.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/add_company.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/get_companies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCompaniesUseCaseProvider = Provider<GetCompanies>(
  (ref) => GetCompanies(ref.watch(companyRepositoryProvider)),
);

final addCompanyUseCaseProvider = Provider<AddCompany>(
  (ref) => AddCompany(ref.watch(companyRepositoryProvider)),
);

class CompaniesNotifier extends AsyncNotifier<List<Company>> {
  bool _isSaving = false;

  @override
  Future<List<Company>> build() {
    return ref.read(getCompaniesUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getCompaniesUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addCompany({
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref.read(addCompanyUseCaseProvider).call(name, notes);
    } on CompanyException catch (error) {
      return error.code == CompanyExceptionCodes.nameDuplicate
          ? SaveResult.duplicate
          : SaveResult.failure;
    } catch (_) {
      return SaveResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return SaveResult.success;
  }
}

final companiesProvider =
    AsyncNotifierProvider<CompaniesNotifier, List<Company>>(
      CompaniesNotifier.new,
    );

import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/data/companies/providers/company_providers.dart';
import 'package:billing_and_sales_management/data/items/providers/item_providers.dart';
import 'package:billing_and_sales_management/data/types/providers/type_providers.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/add_company.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/delete_company.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/get_companies.dart';
import 'package:billing_and_sales_management/domain/companies/usecases/update_company.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCompaniesUseCaseProvider = Provider<GetCompanies>(
  (ref) => GetCompanies(ref.watch(companyRepositoryProvider)),
);

final addCompanyUseCaseProvider = Provider<AddCompany>(
  (ref) => AddCompany(ref.watch(companyRepositoryProvider)),
);

final updateCompanyUseCaseProvider = Provider<UpdateCompany>(
  (ref) => UpdateCompany(ref.watch(companyRepositoryProvider)),
);

final deleteCompanyUseCaseProvider = Provider<DeleteCompany>(
  (ref) => DeleteCompany(
    ref.watch(companyRepositoryProvider),
    ref.watch(typeRepositoryProvider),
    ref.watch(itemRepositoryProvider),
  ),
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

  Future<SaveResult> updateCompany({
    required String id,
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref.read(updateCompanyUseCaseProvider).call(id, name, notes);
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
    ref.invalidate(typesProvider);
    ref.invalidate(itemsProvider);

    return SaveResult.success;
  }

  Future<DeleteResult> deleteCompany(String id) async {
    if (_isSaving) return DeleteResult.failure;

    _isSaving = true;
    try {
      await ref.read(deleteCompanyUseCaseProvider).call(id);
    } on CompanyException catch (error) {
      return error.code == CompanyExceptionCodes.inUse
          ? DeleteResult.blocked
          : DeleteResult.failure;
    } catch (_) {
      return DeleteResult.failure;
    } finally {
      _isSaving = false;
    }

    await refresh();

    return DeleteResult.success;
  }
}

final companiesProvider =
    AsyncNotifierProvider<CompaniesNotifier, List<Company>>(
      CompaniesNotifier.new,
    );

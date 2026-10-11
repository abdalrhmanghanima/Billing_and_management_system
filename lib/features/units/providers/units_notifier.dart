import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/data/units/providers/unit_providers.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/domain/units/usecases/add_unit.dart';
import 'package:billing_and_sales_management/domain/units/usecases/get_units.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUnitsUseCaseProvider = Provider<GetUnits>(
  (ref) => GetUnits(ref.watch(unitRepositoryProvider)),
);

final addUnitUseCaseProvider = Provider<AddUnit>(
  (ref) => AddUnit(ref.watch(unitRepositoryProvider)),
);

class UnitsNotifier extends AsyncNotifier<List<Unit>> {
  bool _isSaving = false;

  @override
  Future<List<Unit>> build() {
    return ref.read(getUnitsUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getUnitsUseCaseProvider).call(),
    );
  }

  Future<SaveResult> addUnit({
    required String name,
    required String notes,
  }) async {
    if (_isSaving) return SaveResult.failure;

    _isSaving = true;
    try {
      await ref.read(addUnitUseCaseProvider).call(name, notes);
    } on UnitException catch (error) {
      return error.code == UnitExceptionCodes.nameDuplicate
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

final unitsProvider = AsyncNotifierProvider<UnitsNotifier, List<Unit>>(
  UnitsNotifier.new,
);

import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:billing_and_sales_management/features/units/providers/units_notifier.dart';
import 'package:billing_and_sales_management/features/units/widgets/unit_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitsScreen extends ConsumerStatefulWidget {
  const UnitsScreen({super.key});

  @override
  ConsumerState<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends ConsumerState<UnitsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  bool _isDeleting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddUnitSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.addUnit.tr(),
      builder: (_) => const UnitFormSheet(),
    );
  }

  void _openEditUnitSheet(Unit unit) {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.editUnit.tr(),
      builder: (_) => UnitFormSheet(existing: unit),
    );
  }

  Future<void> _confirmDeleteUnit(Unit unit) async {
    if (_isDeleting) return;

    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: AppTranslate.deleteUnitQuestion.tr(),
      message: AppTranslate.deleteConfirmationMessage.tr(
        namedArgs: {'name': unit.name},
      ),
    );

    if (!confirmed || !mounted) return;

    setState(() => _isDeleting = true);

    final result = await ref.read(unitsProvider.notifier).deleteUnit(unit.id);

    if (!mounted) return;

    setState(() => _isDeleting = false);

    switch (result) {
      case DeleteResult.success:
        CustomSnackbar.showSuccess(
          context,
          AppTranslate.unitDeletedSuccessfully.tr(),
        );
      case DeleteResult.blocked:
        CustomSnackbar.showError(
          context,
          AppTranslate.cannotDeleteUnitRightNow.tr(),
        );
      case DeleteResult.failure:
        CustomSnackbar.showError(context, AppTranslate.couldNotDeleteUnit.tr());
    }
  }

  List<Unit> _filter(List<Unit> units) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return units;

    return units
        .where((unit) => unit.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final unitsState = ref.watch(unitsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTranslate.units.tr(),
        subtitle: AppTranslate.unitsSubtitle.tr(),
      ),
      floatingActionButton: _AddUnitButton(onPressed: _openAddUnitSheet),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.base.h),
              CustomSearchBar(
                controller: _searchController,
                hint: AppTranslate.searchUnits.tr(),
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: unitsState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: AppTranslate.couldNotLoadUnits.tr(),
                    message: error is UnitException
                        ? error.message
                        : AppTranslate.somethingWentWrong.tr(),
                    onRetry: () => ref.read(unitsProvider.notifier).refresh(),
                  ),
                  data: (units) => _UnitsList(
                    units: _filter(units),
                    isSearching: _query.trim().isNotEmpty,
                    onAddUnit: _openAddUnitSheet,
                    onEditUnit: _openEditUnitSheet,
                    onDeleteUnit: _confirmDeleteUnit,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.pageBottom.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitsList extends StatelessWidget {
  const _UnitsList({
    required this.units,
    required this.isSearching,
    required this.onAddUnit,
    required this.onEditUnit,
    required this.onDeleteUnit,
  });

  final List<Unit> units;
  final bool isSearching;
  final VoidCallback onAddUnit;
  final ValueChanged<Unit> onEditUnit;
  final ValueChanged<Unit> onDeleteUnit;

  @override
  Widget build(BuildContext context) {
    if (units.isEmpty) {
      if (isSearching) {
        return CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: AppTranslate.noUnitsFound.tr(),
          message: AppTranslate.noUnitsMatchSearch.tr(),
        );
      }

      return CustomEmptyState(
        icon: Icons.table_chart_outlined,
        iconColor: context.palette.cyanText,
        iconBackgroundColor: context.palette.cyanLight,
        title: AppTranslate.noUnitsDefined.tr(),
        message: AppTranslate.definePackagingUnitsMessage.tr(),
        action: CustomButton(
          text: AppTranslate.plusAddUnit.tr(),
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddUnit,
        ),
      );
    }

    return ListView.separated(
      itemCount: units.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final unit = units[index];

        return CustomEntityTile(
          avatarIcon: Icons.table_chart_outlined,
          avatarTone: EntityAvatarTone.cyan,
          title: unit.name,
          subtitle: unit.notes.isEmpty
              ? AppTranslate.unitOfMeasurement.tr()
              : unit.notes,
          showChevron: false,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                icon: Icons.edit_outlined,
                onPressed: () => onEditUnit(unit),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                tooltip: AppTranslate.edit.tr(),
              ),
              SizedBox(width: AppSpacing.xs.w),
              CustomIconButton(
                icon: Icons.delete_outline,
                onPressed: () => onDeleteUnit(unit),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                foregroundColor: AppColors.error,
                tooltip: AppTranslate.delete.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddUnitButton extends StatelessWidget {
  const _AddUnitButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.fabSize.r;

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.fab,
      ),
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.add,
              size: AppDimensions.iconLg.r,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

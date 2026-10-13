import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeFormSheet extends ConsumerStatefulWidget {
  const TypeFormSheet({super.key, this.existing});

  final ItemType? existing;

  @override
  ConsumerState<TypeFormSheet> createState() => _TypeFormSheetState();
}

class _TypeFormSheetState extends ConsumerState<TypeFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;

  Company? _selectedCompany;
  String? _companyError;
  String? _nameError;
  bool _isSaving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _notesController = TextEditingController(
      text: widget.existing?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final company = _selectedCompany;
    final name = _nameController.text.trim();

    if (company == null || name.isEmpty) {
      setState(() {
        _companyError = company == null
            ? AppTranslate.companyNameRequired.tr()
            : null;
        _nameError = name.isEmpty ? AppTranslate.typeNameRequired.tr() : null;
      });
      return;
    }

    setState(() {
      _companyError = null;
      _nameError = null;
      _isSaving = true;
    });

    final notifier = ref.read(typesProvider.notifier);
    final result = _isEditing
        ? await notifier.updateType(
            id: widget.existing!.id,
            companyId: company.id,
            companyName: company.name,
            name: name,
            notes: _notesController.text,
          )
        : await notifier.addType(
            companyId: company.id,
            companyName: company.name,
            name: name,
            notes: _notesController.text,
          );

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(
          context,
          _isEditing
              ? AppTranslate.typeUpdatedSuccessfully.tr()
              : AppTranslate.typeSavedSuccessfully.tr(),
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = AppTranslate.typeNameAlreadyExists.tr());
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          _isEditing
              ? AppTranslate.couldNotUpdateType.tr()
              : AppTranslate.couldNotSaveType.tr(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companiesProvider);

    return companiesState.when(
      loading: () => SizedBox(
        height: 160,
        child: Center(child: CustomLoading(color: context.palette.accentText)),
      ),
      error: (error, _) => SizedBox(
        height: 160,
        child: CustomErrorState(
          title: AppTranslate.couldNotLoadCompanies.tr(),
          onRetry: () => ref.read(companiesProvider.notifier).refresh(),
        ),
      ),
      data: (companies) {
        if (companies.isEmpty) {
          return CustomEmptyState(
            icon: Icons.business_outlined,
            iconColor: context.palette.cyanText,
            iconBackgroundColor: context.palette.cyanLight,
            title: AppTranslate.noCompaniesAvailable.tr(),
            message: AppTranslate.addCompanyFirstBeforeTypesMessage.tr(),
          );
        }

        if (_selectedCompany == null && _isEditing) {
          _selectedCompany = companies
              .where((company) => company.id == widget.existing!.companyId)
              .firstOrNull;
        }

        return _buildForm(companies);
      },
    );
  }

  Widget _buildForm(List<Company> companies) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomDropdown<Company>(
          label: AppTranslate.companyName.tr(),
          isRequired: true,
          hint: AppTranslate.selectCompany.tr(),
          options: companies,
          value: _selectedCompany,
          labelOf: (company) => company.name,
          enabled: !_isSaving,
          onChanged: (company) {
            setState(() {
              _selectedCompany = company;
              if (_companyError != null) _companyError = null;
            });
          },
        ),
        if (_companyError != null) ...[
          SizedBox(height: AppSpacing.xs.h),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppDimensions.inputHorizontalPadding.w,
            ),
            child: CustomText(
              text: _companyError!,
              style: AppTextStyles.fieldError,
              color: AppColors.error,
            ),
          ),
        ],
        SizedBox(height: AppSpacing.formGroupGap.h),
        CustomTextField(
          controller: _nameController,
          label: AppTranslate.typeName.tr(),
          isRequired: true,
          hint: AppTranslate.enterTypeName.tr(),
          errorText: _nameError,
          enabled: !_isSaving,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
        ),
        SizedBox(height: AppSpacing.formGroupGap.h),
        CustomTextField(
          controller: _notesController,
          label: AppTranslate.notes.tr(),
          hint: AppTranslate.enterNotesOptional.tr(),
          enabled: !_isSaving,
          maxLines: 3,
          minLines: 3,
        ),
        SizedBox(height: AppSpacing.lg.h),
        CustomButton(
          text: _isEditing
              ? AppTranslate.updateType.tr()
              : AppTranslate.saveType.tr(),
          onPressed: _save,
          loading: _isSaving,
        ),
      ],
    );
  }
}

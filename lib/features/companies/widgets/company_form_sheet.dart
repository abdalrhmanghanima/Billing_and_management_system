import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyFormSheet extends ConsumerStatefulWidget {
  const CompanyFormSheet({super.key, this.existing});

  final Company? existing;

  @override
  ConsumerState<CompanyFormSheet> createState() => _CompanyFormSheetState();
}

class _CompanyFormSheetState extends ConsumerState<CompanyFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;

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

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = AppTranslate.companyNameRequired.tr());
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final notifier = ref.read(companiesProvider.notifier);
    final result = _isEditing
        ? await notifier.updateCompany(
            id: widget.existing!.id,
            name: name,
            notes: _notesController.text,
          )
        : await notifier.addCompany(name: name, notes: _notesController.text);

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(
          context,
          _isEditing
              ? AppTranslate.companyUpdatedSuccessfully.tr()
              : AppTranslate.companySavedSuccessfully.tr(),
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = AppTranslate.companyNameAlreadyExists.tr());
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          _isEditing
              ? AppTranslate.couldNotUpdateCompany.tr()
              : AppTranslate.couldNotSaveCompany.tr(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: _nameController,
          label: AppTranslate.companyName.tr(),
          isRequired: true,
          hint: AppTranslate.enterCompanyName.tr(),
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
              ? AppTranslate.updateCompany.tr()
              : AppTranslate.saveCompany.tr(),
          onPressed: _save,
          loading: _isSaving,
        ),
      ],
    );
  }
}

import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyFormSheet extends ConsumerStatefulWidget {
  const CompanyFormSheet({super.key});

  @override
  ConsumerState<CompanyFormSheet> createState() => _CompanyFormSheetState();
}

class _CompanyFormSheetState extends ConsumerState<CompanyFormSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _nameError;
  bool _isSaving = false;

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
      setState(() => _nameError = 'COMPANY NAME is Required');
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final result = await ref
        .read(companiesProvider.notifier)
        .addCompany(name: name, notes: _notesController.text);

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(context, 'Company saved successfully.');
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = 'COMPANY NAME has already existed before');
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not save the company. Please try again.',
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
          label: 'Company Name',
          isRequired: true,
          hint: 'Enter company name',
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
          label: 'Notes',
          hint: 'Enter notes (optional)',
          enabled: !_isSaving,
          maxLines: 3,
          minLines: 3,
        ),
        SizedBox(height: AppSpacing.lg.h),
        CustomButton(
          text: 'Save Company',
          onPressed: _save,
          loading: _isSaving,
        ),
      ],
    );
  }
}

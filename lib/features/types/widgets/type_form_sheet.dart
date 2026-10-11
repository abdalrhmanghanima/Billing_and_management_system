import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeFormSheet extends ConsumerStatefulWidget {
  const TypeFormSheet({super.key});

  @override
  ConsumerState<TypeFormSheet> createState() => _TypeFormSheetState();
}

class _TypeFormSheetState extends ConsumerState<TypeFormSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Company? _selectedCompany;
  String? _companyError;
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

    final company = _selectedCompany;
    final name = _nameController.text.trim();

    if (company == null || name.isEmpty) {
      setState(() {
        _companyError = company == null ? 'COMPANY NAME is Required' : null;
        _nameError = name.isEmpty ? 'TYPE NAME is Required' : null;
      });
      return;
    }

    setState(() {
      _companyError = null;
      _nameError = null;
      _isSaving = true;
    });

    final result = await ref
        .read(typesProvider.notifier)
        .addType(
          companyId: company.id,
          companyName: company.name,
          name: name,
          notes: _notesController.text,
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(context, 'Type saved successfully.');
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = 'TYPE NAME has already existed before');
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not save the type. Please try again.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companiesProvider);

    return companiesState.when(
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CustomLoading(color: AppColors.primary)),
      ),
      error: (error, _) => SizedBox(
        height: 160,
        child: CustomErrorState(
          title: 'Could not load companies',
          onRetry: () => ref.read(companiesProvider.notifier).refresh(),
        ),
      ),
      data: (companies) {
        if (companies.isEmpty) {
          return const CustomEmptyState(
            icon: Icons.business_outlined,
            iconColor: AppColors.cyanDark,
            iconBackgroundColor: AppColors.cyanLight,
            title: 'No Companies Available',
            message:
                'Add a company first before creating types. Types must belong to a company.',
          );
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
          label: 'Company Name',
          isRequired: true,
          hint: 'Select company',
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
          label: 'Type Name',
          isRequired: true,
          hint: 'Enter type name',
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
        CustomButton(text: 'Save Type', onPressed: _save, loading: _isSaving),
      ],
    );
  }
}

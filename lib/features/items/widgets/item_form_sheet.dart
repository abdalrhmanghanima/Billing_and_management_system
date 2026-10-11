import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/features/companies/providers/companies_notifier.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemFormSheet extends ConsumerStatefulWidget {
  const ItemFormSheet({super.key});

  @override
  ConsumerState<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends ConsumerState<ItemFormSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _buyingPriceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Company? _selectedCompany;
  ItemType? _selectedType;

  String? _companyError;
  String? _typeError;
  String? _nameError;
  String? _sellingPriceError;
  String? _buyingPriceError;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _buyingPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onCompanyChanged(Company? company) {
    setState(() {
      _selectedCompany = company;
      if (company == null ||
          (_selectedType != null && _selectedType!.companyId != company.id)) {
        _selectedType = null;
      }
      if (_companyError != null) _companyError = null;
    });
  }

  bool _validatePrices() {
    final sellingText = _sellingPriceController.text.trim();
    final buyingText = _buyingPriceController.text.trim();
    final sellingPrice = double.tryParse(sellingText);
    final buyingPrice = double.tryParse(buyingText);

    setState(() {
      _sellingPriceError = (sellingPrice == null || sellingPrice < 0)
          ? 'SELLING PRICE Must be Greater than or equal Zero'
          : null;
      if (buyingPrice == null || buyingPrice < 0) {
        _buyingPriceError = 'BUYING PRICE Must be Greater than or equal Zero';
      } else if (sellingPrice != null &&
          sellingPrice >= 0 &&
          buyingPrice > sellingPrice) {
        _buyingPriceError =
            'BUYING PRICE Must be less than or equal SELLING PRICE';
      } else {
        _buyingPriceError = null;
      }
    });

    return _sellingPriceError == null && _buyingPriceError == null;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final company = _selectedCompany;
    final type = _selectedType;
    final name = _nameController.text.trim();

    final companyInvalid = company == null;
    final typeInvalid = type == null;
    final nameInvalid = name.isEmpty;

    final pricesValid = _validatePrices();

    if (companyInvalid || typeInvalid || nameInvalid || !pricesValid) {
      setState(() {
        _companyError = companyInvalid ? 'COMPANY NAME is Required' : null;
        _typeError = typeInvalid ? 'TYPE NAME is Required' : null;
        _nameError = nameInvalid ? 'ITEM NAME is Required' : null;
      });
      return;
    }

    setState(() {
      _companyError = null;
      _typeError = null;
      _nameError = null;
      _isSaving = true;
    });

    final sellingPrice = double.parse(_sellingPriceController.text.trim());
    final buyingPrice = double.parse(_buyingPriceController.text.trim());

    final result = await ref
        .read(itemsProvider.notifier)
        .addItem(
          companyId: company.id,
          companyName: company.name,
          typeId: type.id,
          typeName: type.name,
          name: name,
          sellingPrice: sellingPrice,
          buyingPrice: buyingPrice,
          notes: _notesController.text,
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(context, 'Item saved successfully.');
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = 'ITEM NAME has already existed before');
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not save the item. Please try again.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final companiesState = ref.watch(companiesProvider);
    final typesState = ref.watch(typesProvider);

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
                'Add a company first before creating items. Items must belong to a company.',
          );
        }

        return typesState.when(
          loading: () => const SizedBox(
            height: 160,
            child: Center(child: CustomLoading(color: AppColors.primary)),
          ),
          error: (error, _) => SizedBox(
            height: 160,
            child: CustomErrorState(
              title: 'Could not load types',
              onRetry: () => ref.read(typesProvider.notifier).refresh(),
            ),
          ),
          data: (types) {
            if (types.isEmpty) {
              return const CustomEmptyState(
                icon: Icons.description_outlined,
                iconColor: AppColors.primary,
                iconBackgroundColor: AppColors.primarySubtle,
                title: 'No Types Available',
                message:
                    'Add a type first before creating items. Items must have a type.',
              );
            }

            return _buildForm(companies, types);
          },
        );
      },
    );
  }

  Widget _buildForm(List<Company> companies, List<ItemType> types) {
    final filteredTypes = _selectedCompany == null
        ? types
        : types
              .where((type) => type.companyId == _selectedCompany!.id)
              .toList();

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDropdown<Company>(
            label: 'Company',
            isRequired: true,
            hint: 'Select company',
            options: companies,
            value: _selectedCompany,
            labelOf: (company) => company.name,
            enabled: !_isSaving,
            onChanged: _onCompanyChanged,
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
          CustomDropdown<ItemType>(
            label: 'Type',
            isRequired: true,
            hint: _selectedCompany == null
                ? 'Select company first'
                : 'Select type',
            options: filteredTypes,
            value: _selectedType,
            labelOf: (type) => type.name,
            enabled: !_isSaving && _selectedCompany != null,
            onChanged: (type) {
              setState(() {
                _selectedType = type;
                if (_typeError != null) _typeError = null;
              });
            },
          ),
          if (_typeError != null) ...[
            SizedBox(height: AppSpacing.xs.h),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: AppDimensions.inputHorizontalPadding.w,
              ),
              child: CustomText(
                text: _typeError!,
                style: AppTextStyles.fieldError,
                color: AppColors.error,
              ),
            ),
          ],
          SizedBox(height: AppSpacing.formGroupGap.h),
          CustomTextField(
            controller: _nameController,
            label: 'Item Name',
            isRequired: true,
            hint: 'Enter item name',
            errorText: _nameError,
            enabled: !_isSaving,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          SizedBox(height: AppSpacing.formGroupGap.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _sellingPriceController,
                  label: 'Selling Price',
                  isRequired: true,
                  hint: '0.00',
                  errorText: _sellingPriceError,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_sellingPriceError != null) {
                      setState(() => _sellingPriceError = null);
                    }
                  },
                ),
              ),
              SizedBox(width: AppSpacing.cardGap.w),
              Expanded(
                child: CustomTextField(
                  controller: _buyingPriceController,
                  label: 'Buying Price',
                  isRequired: true,
                  hint: '0.00',
                  errorText: _buyingPriceError,
                  enabled: !_isSaving,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_buyingPriceError != null) {
                      setState(() => _buyingPriceError = null);
                    }
                  },
                ),
              ),
            ],
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
          CustomButton(text: 'Save Item', onPressed: _save, loading: _isSaving),
        ],
      ),
    );
  }
}

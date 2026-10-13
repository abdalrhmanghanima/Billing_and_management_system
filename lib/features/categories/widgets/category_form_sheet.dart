import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/features/categories/providers/categories_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryFormSheet extends ConsumerStatefulWidget {
  const CategoryFormSheet({super.key, this.existing});

  final Category? existing;

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
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
      setState(() => _nameError = AppTranslate.categoryNameRequired.tr());
      return;
    }

    setState(() {
      _nameError = null;
      _isSaving = true;
    });

    final notifier = ref.read(categoriesProvider.notifier);
    final result = _isEditing
        ? await notifier.updateCategory(
            id: widget.existing!.id,
            name: name,
            notes: _notesController.text,
          )
        : await notifier.addCategory(name: name, notes: _notesController.text);

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(
          context,
          _isEditing
              ? AppTranslate.categoryUpdatedSuccessfully.tr()
              : AppTranslate.categorySavedSuccessfully.tr(),
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(
          () => _nameError = AppTranslate.categoryNameAlreadyExists.tr(),
        );
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          _isEditing
              ? AppTranslate.couldNotUpdateCategory.tr()
              : AppTranslate.couldNotSaveCategory.tr(),
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
          label: AppTranslate.categoryName.tr(),
          isRequired: true,
          hint: AppTranslate.enterCategoryName.tr(),
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
              ? AppTranslate.updateCategory.tr()
              : AppTranslate.saveCategory.tr(),
          onPressed: _save,
          loading: _isSaving,
        ),
      ],
    );
  }
}

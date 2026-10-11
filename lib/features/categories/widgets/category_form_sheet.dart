import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:billing_and_sales_management/features/categories/providers/categories_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
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
      setState(() => _nameError = 'Category Name is Required');
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
              ? 'Category updated successfully.'
              : 'Category saved successfully.',
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = 'Category Name has already existed before');
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          _isEditing
              ? 'Could not update the category. Please try again.'
              : 'Could not save the category. Please try again.',
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
          label: 'Category Name',
          isRequired: true,
          hint: 'Enter category name',
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
          text: _isEditing ? 'Update Category' : 'Save Category',
          onPressed: _save,
          loading: _isSaving,
        ),
      ],
    );
  }
}

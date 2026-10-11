import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:billing_and_sales_management/features/types/providers/types_notifier.dart';
import 'package:billing_and_sales_management/features/types/widgets/type_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypesScreen extends ConsumerStatefulWidget {
  const TypesScreen({super.key});

  @override
  ConsumerState<TypesScreen> createState() => _TypesScreenState();
}

class _TypesScreenState extends ConsumerState<TypesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  bool _isDeleting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddTypeSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: 'Add Type',
      builder: (_) => const TypeFormSheet(),
    );
  }

  void _openEditTypeSheet(ItemType type) {
    showAppBottomSheet<void>(
      context: context,
      title: 'Edit Type',
      builder: (_) => TypeFormSheet(existing: type),
    );
  }

  Future<void> _confirmDeleteType(ItemType type) async {
    if (_isDeleting) return;

    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: 'Delete Type?',
      message:
          'Are you sure you want to delete "${type.name}"? '
          'This action cannot be undone.',
    );

    if (!confirmed || !mounted) return;

    setState(() => _isDeleting = true);

    final result = await ref.read(typesProvider.notifier).deleteType(type.id);

    if (!mounted) return;

    setState(() => _isDeleting = false);

    switch (result) {
      case DeleteResult.success:
        CustomSnackbar.showSuccess(context, 'Type deleted successfully.');
      case DeleteResult.blocked:
        final error = ref
            .read(typesProvider)
            .maybeWhen(
              error: (e, _) => e is TypeException ? e : null,
              orElse: () => null,
            );
        CustomSnackbar.showError(
          context,
          error?.message ??
              'Cannot delete this type because it is used by existing items.',
        );
      case DeleteResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not delete the type. Please try again.',
        );
    }
  }

  List<ItemType> _filter(List<ItemType> types) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return types;

    return types
        .where(
          (type) =>
              type.name.toLowerCase().contains(query) ||
              type.companyName.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final typesState = ref.watch(typesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Types',
        subtitle: 'Item Classifications',
      ),
      floatingActionButton: _AddTypeButton(onPressed: _openAddTypeSheet),
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
                hint: 'Search types...',
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: typesState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: 'Could not load types',
                    message: error is TypeException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: () => ref.read(typesProvider.notifier).refresh(),
                  ),
                  data: (types) => _TypesList(
                    types: _filter(types),
                    isSearching: _query.trim().isNotEmpty,
                    onAddType: _openAddTypeSheet,
                    onEditType: _openEditTypeSheet,
                    onDeleteType: _confirmDeleteType,
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

class _TypesList extends StatelessWidget {
  const _TypesList({
    required this.types,
    required this.isSearching,
    required this.onAddType,
    required this.onEditType,
    required this.onDeleteType,
  });

  final List<ItemType> types;
  final bool isSearching;
  final VoidCallback onAddType;
  final ValueChanged<ItemType> onEditType;
  final ValueChanged<ItemType> onDeleteType;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) {
      if (isSearching) {
        return const CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: 'No Types Found',
          message: 'No types match your search.',
        );
      }

      return CustomEmptyState(
        icon: Icons.description_outlined,
        title: 'No Types Found',
        message: 'Create item categories/types under companies.',
        action: CustomButton(
          text: '+ Add Type',
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddType,
        ),
      );
    }

    return ListView.separated(
      itemCount: types.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final type = types[index];

        return CustomEntityTile(
          avatarIcon: Icons.description_outlined,
          avatarTone: EntityAvatarTone.primary,
          title: type.name,
          subtitle: type.companyName,
          showChevron: false,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                icon: Icons.edit_outlined,
                onPressed: () => onEditType(type),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                tooltip: 'Edit',
              ),
              SizedBox(width: AppSpacing.xs.w),
              CustomIconButton(
                icon: Icons.delete_outline,
                onPressed: () => onDeleteType(type),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                foregroundColor: AppColors.error,
                tooltip: 'Delete',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddTypeButton extends StatelessWidget {
  const _AddTypeButton({required this.onPressed});

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

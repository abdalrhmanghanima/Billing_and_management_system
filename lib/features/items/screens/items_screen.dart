import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/items/widgets/item_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  bool _isDeleting = false;
  bool _isRefreshing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddItemSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.addItem.tr(),
      builder: (_) => const ItemFormSheet(),
    );
  }

  void _openEditItemSheet(Item item) {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.editItem.tr(),
      builder: (_) => ItemFormSheet(existing: item),
    );
  }

  Future<void> _confirmDeleteItem(Item item) async {
    if (_isDeleting) return;

    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: AppTranslate.deleteItemQuestion.tr(),
      message: AppTranslate.deleteConfirmationMessage.tr(
        namedArgs: {'name': item.name},
      ),
    );

    if (!confirmed || !mounted) return;

    setState(() => _isDeleting = true);

    final result = await ref.read(itemsProvider.notifier).deleteItem(item.id);

    if (!mounted) return;

    setState(() => _isDeleting = false);

    switch (result) {
      case DeleteResult.success:
        CustomSnackbar.showSuccess(
          context,
          AppTranslate.itemDeletedSuccessfully.tr(),
        );
      case DeleteResult.blocked:
        CustomSnackbar.showError(
          context,
          AppTranslate.cannotDeleteItemRightNow.tr(),
        );
      case DeleteResult.failure:
        CustomSnackbar.showError(context, AppTranslate.couldNotDeleteItem.tr());
    }
  }

  List<Item> _filter(List<Item> items) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items
        .where(
          (item) =>
              item.name.toLowerCase().contains(query) ||
              item.companyName.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      await ref.read(itemsProvider.notifier).refresh();
    } finally {
      _isRefreshing = false;
    }
  }

  String _formatPrice(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTranslate.items.tr(),
        subtitle: AppTranslate.itemsSubtitle.tr(),
        showBackArrow: false,
      ),
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
                hint: AppTranslate.searchItems.tr(),
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: RefreshIndicator(
                  color: context.palette.accentText,
                  onRefresh: _refresh,
                  child: itemsState.when(
                    loading: () => const CustomSkeletonList(count: 4),
                    error: (error, _) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: CustomErrorState(
                            title: AppTranslate.couldNotLoadItems.tr(),
                            message: error is ItemException
                                ? error.message
                                : AppTranslate.somethingWentWrong.tr(),
                            onRetry: () =>
                                ref.read(itemsProvider.notifier).refresh(),
                          ),
                        ),
                      ],
                    ),
                    data: (items) => _ItemsList(
                      items: _filter(items),
                      isSearching: _query.trim().isNotEmpty,
                      onAddItem: _openAddItemSheet,
                      onEditItem: _openEditItemSheet,
                      onDeleteItem: _confirmDeleteItem,
                      formatPrice: _formatPrice,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.pageBottom.h),
            ],
          ),
        ),
      ),
      floatingActionButton: _AddItemButton(onPressed: _openAddItemSheet),
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList({
    required this.items,
    required this.isSearching,
    required this.onAddItem,
    required this.onEditItem,
    required this.onDeleteItem,
    required this.formatPrice,
  });

  final List<Item> items;
  final bool isSearching;
  final VoidCallback onAddItem;
  final ValueChanged<Item> onEditItem;
  final ValueChanged<Item> onDeleteItem;
  final String Function(double) formatPrice;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final emptyState = isSearching
          ? CustomEmptyState(
              icon: Icons.search_off_outlined,
              title: AppTranslate.noItemsFound.tr(),
              message: AppTranslate.noItemsMatchSearch.tr(),
            )
          : CustomEmptyState(
              icon: Icons.inventory_2_outlined,
              iconColor: context.palette.accentText,
              iconBackgroundColor: context.palette.primarySubtle,
              title: AppTranslate.noItemsInCatalog.tr(),
              message: AppTranslate.registerProductInventoryMessage.tr(),
              action: CustomButton(
                text: AppTranslate.plusAddItem.tr(),
                size: CustomButtonSize.small,
                width: 200.w,
                onPressed: onAddItem,
              ),
            );

      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [SliverFillRemaining(hasScrollBody: false, child: emptyState)],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final item = items[index];

        return CustomEntityTile(
          avatarIcon: Icons.inventory_2_outlined,
          avatarTone: EntityAvatarTone.primary,
          title: item.name,
          subtitle: '${item.companyName} • ${item.typeName}',
          trailingText: formatPrice(item.sellingPrice),
          showChevron: false,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                icon: Icons.edit_outlined,
                onPressed: () => onEditItem(item),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                tooltip: AppTranslate.edit.tr(),
              ),
              SizedBox(width: AppSpacing.xs.w),
              CustomIconButton(
                icon: Icons.delete_outline,
                onPressed: () => onDeleteItem(item),
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

class _AddItemButton extends StatelessWidget {
  const _AddItemButton({required this.onPressed});

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

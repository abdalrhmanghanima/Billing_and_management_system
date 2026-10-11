import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/features/items/widgets/item_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddItemSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: 'Add Item',
      builder: (_) => const ItemFormSheet(),
    );
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

  String _formatPrice(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Items',
        subtitle: 'Product Catalog',
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
                hint: 'Search items...',
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: itemsState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: 'Could not load items',
                    message: error is ItemException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: () => ref.read(itemsProvider.notifier).refresh(),
                  ),
                  data: (items) => _ItemsList(
                    items: _filter(items),
                    isSearching: _query.trim().isNotEmpty,
                    onAddItem: _openAddItemSheet,
                    formatPrice: _formatPrice,
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
    required this.formatPrice,
  });

  final List<Item> items;
  final bool isSearching;
  final VoidCallback onAddItem;
  final String Function(double) formatPrice;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      if (isSearching) {
        return const CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: 'No Items Found',
          message: 'No items match your search.',
        );
      }

      return CustomEmptyState(
        icon: Icons.inventory_2_outlined,
        iconColor: AppColors.primary,
        iconBackgroundColor: AppColors.primarySubtle,
        title: 'No Items in Catalog',
        message: 'Register product inventory to start selling.',
        action: CustomButton(
          text: '+ Add Item',
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddItem,
        ),
      );
    }

    return ListView.separated(
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
